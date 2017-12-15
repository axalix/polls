module Concerns::Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, class_name: 'Comment', as: :commented_obj
    scope :by,  -> (user) { where user_id: user.id }
  end

  def add_comment!(text:, user:)
    Comment.create!(text: text, user: user, obj: self)
  end

  def comment_by_id(id)
    Comment.find_by_obj(id: id, obj: self)
  end
end
