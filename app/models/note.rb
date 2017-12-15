class Note < ActiveRecord::Base
  belongs_to  :user, class_name: 'User'

  validates   :status, inclusion: { in: %w(pending active deleted) }, presence: true
  validates   :kind,   inclusion: { in: %w(bio) }, presence: true
  validates   :source, inclusion: { in: %w(TinderBoost Tinder) }, presence: true

  scope :pending, -> { where(status: :pending) }
  scope :active,  -> { where(status: :active)  }
  scope :deleted, -> { where(status: :deleted) }

  scope :by_kind, -> (kind) { where(kind: kind) }
  scope :bio,     -> { by_kind(:bio) }

  scope :visible, -> { where(status: [:pending, :active]) }

  state_machine :status, initial: :active do
    event (:deactivate) { transition to: :deleted }
  end
end
