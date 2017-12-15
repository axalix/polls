module Concerns::Taggable
  extend ActiveSupport::Concern

  included do
    has_many :tags, class_name: 'Tag', as: :tagged_obj
    scope :by,  -> (user) { where user_id: user.id }
  end

  def rate!(id:, text:, user:)
    Tag.find_or_create_and_rate!(id: id, text: text, user: user, obj: self)
  end

  def tag_by_id(id)
    Tag.find_by_obj(id: id, obj: self)
  end
end
