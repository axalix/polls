class TinderProfile < ActiveRecord::Base
  validates :uid, presence: true, uniqueness: true

  scope :age_at_least,  -> (years)  { where "date_part('year', age(now(), birth_date)) >= ?", years }
  scope :age_no_more,   -> (years)  { where "date_part('year', age(now(), birth_date)) <= ?", years }
  scope :gender,        -> (gender) { where gender: gender }

  def age
    now = DateTime.now
    now.year - birth_date.year - ((birth_date.month > now.month or (birth_date.month >= now.month and birth_date.day > now.day)) ? 1 : 0)
  end

end
