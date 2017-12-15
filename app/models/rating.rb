class Rating < ActiveRecord::Base
  belongs_to :rated_obj, polymorphic: true
  belongs_to :user, class_name: 'User'

  validates_presence_of   :score
  validates_presence_of   :rated_obj
  validates_uniqueness_of :user_id, :scope => [:rated_obj_id, :rated_obj_type]

  class << self


    def create_rating!(user:, score:, obj:)
      rating = new(user: user, score: score, rated_obj: obj)
      rating.save! if rating.valid?
      rating
    end
  end
end
