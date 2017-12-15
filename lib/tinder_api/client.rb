class TinderApi::Client
  def initialize
    @requester = TinderApi::Requester.new
  end

  def dislike(user_id)
    @requester.get_request("pass/#{user_id}")
  end

  def fetch_updates(last_activity_time = Time.now)
    @requester.post_request(
      :updates,
      last_activity_date: Utils::Misc.format_time(last_activity_time)
    )
  end

  def get_nearby_users
    @requester.get_request('user/recs')
  end

  def info_for_user(user_id)
    @requester.get_request("user/#{user_id}")
  end

  def like(user_id)
    @requester.get_request("like/#{user_id}")
  end

  def profile
    @requester.get_request(:profile)
  end

  def send_message(user_id, message)
    @requester.post_request(
      "user/matches/#{user_id}",
      message: message
    )
  end

  def sign_in(facebook_id, facebook_token)
    @requester.auth_request(facebook_id, facebook_token)
  end

  def update_location(latitude, longitude)
    @requester.post_request("user/ping", lat: latitude, lon: longitude)
  end

  # https://gist.github.com/rtt/10403467
  def distance(proximity)
    proximity = 3 unless proximity.is_a?(Integer)
    proximity = 3 if proximity < 3
    proximity = 100 if proximity > 100
    @requester.post_request("profile", distance_filter: proximity)
  end

  def get_local_users( proximity)
    distance(proximity)
    get_nearby_users
  end

  def gender(gnd)
    r = 1
    r = -1 if gnd == :both
    r = 0 if gnd == :men
    r = 1 if gnd == :women
    @requester.post_request("profile", gender_filter: r) unless r == nil
  end

  def age(from, to)
    @requester.post_request("profile", age_filter_min: from, age_filter_max: to)
  end
end

