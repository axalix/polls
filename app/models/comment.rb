class Comment < ActiveRecord::Base
  include Concerns::Rateable

  belongs_to  :commented_obj, polymorphic: true
  belongs_to  :user, class_name: 'User'

  validates_presence_of :text
  validates_presence_of :commented_obj

  scope :active,      -> { where(status: :active) }
  scope :created_by,  -> (user) { where(user: user) }
  scope :visible,     -> { active }

  state_machine :status, initial: :active do
    event (:deactivate) { transition to: :deleted }
  end

  class << self
    def create!(text:, user:, obj:)
      comment = new(user: user, text: text, commented_obj: obj)
      return comment unless comment.valid?
      comment.save!
      comment
    end

    def find_by_obj(id:, obj:)
      find_by!(id: id, commented_obj: obj)
    end
  end
end
