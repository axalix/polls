class Survey < ActiveRecord::Base
  include Concerns::Commentable

  before_create :set_url_hash

  has_many    :survey_entities, class_name: 'SurveyEntity',  dependent: :destroy
  has_many    :survey_votes,    class_name: 'SurveyVote',    dependent: :destroy
  belongs_to  :user, class_name: 'User'

  validates   :status,            inclusion: { in: %w(pending active stopped deleted) }
  validates   :publicity_status,  inclusion: { in: %w(private public) }
  validates   :kind,              inclusion: { in: %w(photo text profile) }, presence: true

  scope :pending, -> { where(status: :pending) }
  scope :active,  -> { where(status: :active)  }
  scope :stopped, -> { where(status: :stopped) }
  scope :deleted, -> { where(status: :deleted) }

  scope :publicity_private, -> { where(publicity_status: :private) }
  scope :publicity_public,  -> { where(publicity_status: :public) }

  scope :visible, -> { where(status: [:pending, :active, :stopped]) }

  scope :not_voted_by, -> (user) {
    joins("LEFT JOIN (SELECT survey_id FROM survey_votes WHERE user_id = #{user.id}) voted ON surveys.id = voted.survey_id").
    where("voted.survey_id IS NULL")
  }

  scope :random, -> { order("RANDOM()").first }

  scope :public_limit_not_exceeded, -> { where arel_table[:public_votes_done].lt(arel_table[:public_votes_limit]) }
  scope :not_created_by,  -> (user) { where.not user_id: user.id }
  scope :votable_by,      -> (user) { active.not_voted_by(user).not_created_by(user) }
  scope :public_for,      -> (user) { publicity_public.public_limit_not_exceeded.votable_by(user) }
  scope :private_for,     -> (user) { publicity_private.votable_by(user) }

  state_machine :status, initial: :pending do
    state :pending, :active, :stopped, :deleted
    event (:activate)   { transition [:active, :pending, :stopped] => :active }
    event (:stop)       { transition [:stopped, :pending, :active] => :stopped }
    event (:deactivate) { transition to: :deleted }
  end

  state_machine :publicity_status, initial: :private

  def validate_and_activate!
    activate! if entities_number_validation
  end

  def entities_count_valid?
    total_entities = survey_entities.reject(&:marked_for_destruction?).size
    (self.kind != 'profile' && total_entities > 1) || (self.kind == 'profile' && total_entities == 1)
  end

  def entities_number_validation
    unless entities_count_valid?
      errors.add(:status, 'There should be ' + ((self.kind == 'profile') ? 'one entity assigned' : 'at least two entities assigned'))
      return false
    end
    true
  end

  def vote!(vote_attr = {})
    SurveyVote.process!(self, vote_attr)
  end

  protected

  def set_url_hash
    self.url_hash = SecureRandom.hex
  end
end
