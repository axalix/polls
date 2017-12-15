module Concerns::Rateable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, class_name: 'Rating', as: :rated_obj
    scope :by,  -> (user) { where user_id: user.id }
  end

  def rate!(user, score)
    rating = nil
    Rating.transaction do
      rating = Rating.find_by(user: user, rated_obj: self)
      if rating
        rating.destroy! if rating.score == 1
        sign = -1
      else
        rating = Rating.create_rating!(user: user, score: score, obj: self)
        break unless rating.errors.empty?
        sign = 1
      end
      if self.respond_to?(:num_votes=) && self.respond_to?(:total_score=)
        self.class.update_counters(self.id, num_votes: sign * 1, total_score: sign * score)
        self.num_votes = self.num_votes + sign * 1
        self.total_score = self.total_score + sign * score
      end
    end
    rating
  end
end
