class Tag < ActiveRecord::Base
  include Concerns::Rateable

  belongs_to :tagged_obj, polymorphic: true
  belongs_to :user, class_name: 'User'

  validates               :text, inclusion: { in: %w(photo selfie something\ else) }, presence: true
  validates_presence_of   :tagged_obj
  validates_uniqueness_of :text, :scope => [:tagged_obj_id, :tagged_obj_type]

  scope :active,      -> { where(status: :active) }
  scope :created_by,  -> (user) { where(user: user) }
  scope :visible,     -> { active }

  class << self
    def find_or_create_and_rate!(id:, text:, user:, obj:)
      tag = nil
      Tag.transaction do
        tag = find_by_context(id: id, text: text, obj: obj)
        tag = create!(text: text, user: user, obj: obj) unless tag
        return tag unless tag.errors.blank?
        tag.rate!(user, 1)
      end
      tag
    end

    def find_by_obj(id:, obj:)
      find_by!(id: id, tagged_obj: obj)
    end

    def find_by_context(id:, text:, obj:)
      tag = nil
      tag = find_by(id: id, tagged_obj: obj) if id
      tag = find_by(text: text, tagged_obj: obj) unless tag
      tag
    end

    def create!(text:, user:, obj:)
      tag = new(user: user, text: text, tagged_obj: obj)
      return tag unless tag.valid?
      tag.save!
      tag
    end
  end
end
