class Scrapers::Tinder
  attr_reader :handler

  def initialize(fb_id, fb_token)
    @handler = TinderApi::Client.new
    @handler.sign_in(fb_id, fb_token)
  end

  def collect_users(script, fn)
    script.each do |node|
      request = request_by_node(node)
      handler.update_location(request[:latitude], request[:longitude])
      handler.gender(request[:gender])
      handler.age(request[:age_min], request[:age_max])

      node[:iterations_count].times do
        distance_m = refresh
        users = get_users(distance_m)
        fn.call(request.merge!(distance: distance_m), users)
        Utils::Misc.sleep_by_range node[:delays_range_sec]
        p users.count
      end

      p 'sleeping...'
      Utils::Misc.sleep_by_range node[:final_delay_sec]
    end
  end

  private

  def refresh
    distance_mi = Random.rand(80) + 10
    handler.distance(distance_mi)
    Utils::Misc.miles_to_meters(distance_mi)
  end

  def request_by_node(node)
    location = Geo::Location.send(node[:location])
    {
      age_min:    node[:ages_range][0],
      age_max:    node[:ages_range][1],
      latitude:   location[:latitude]  + Utils::Misc.random_by_range(node[:scatter]),
      longitude:  location[:longitude] + Utils::Misc.random_by_range(node[:scatter]),
      gender:     Utils::Misc.random_by_weight(node[:gender_probability])
    }
  end

  def get_users(distance_m)
    users = []
    r = handler.get_nearby_users
    if r['results']
      r['results'].each do |user|
        users << {
          uid:        user['_id'],
          name:       user['name'].force_encoding('UTF-8'),
          bio:        user['bio'].force_encoding('UTF-8'),
          gender:     user['gender'],
          birth_date: user['birth_date'],
          photo:      (user['photos'] && user['photos'][0]) ? user['photos'][0]['url'] : '',
          distance:   (user['distance_mi'] && user['distance_mi'] > 0) ? Utils::Misc.miles_to_meters(user['distance_mi']) : distance_m,
          json:       user.to_json
        }
      end
    end
    users
  end
end

#----------------------------------------------
# {
#   "distance_mi"   =>9,
#   "common_like_count"   =>0,
#   "common_friend_count"   =>0,
#   "common_likes"   =>   [
#
#   ],
#   "common_friends"   =>   [
#
#   ],
#   "_id"   =>"54a0604f8dd2e01c65229738",
#   "bio"   =>"The truth is we all go through changes. But when your change comes don't forget who you are.",
#   "birth_date"   =>"1992-01-03T00:00:00.000   Z",
#   "gender"   =>1,
#   "name"   =>"Alisa",
#   "ping_time"   =>"2015-01-11T16:36:56.861   Z",
#   "photos"   =>   [
#     {
#       "ydistance_percent"         =>0.800000011920929,
#       "id"         =>"4cace1a7-8979-4ab3-aa70-549b28502951",
#       "xoffset_percent"         =>0.08611111342906952,
#       "yoffset_percent"         =>0.05694444477558136,
#       "xdistance_percent"         =>0.7986111044883728,
#       "fileName"         =>"4cace1a7-8979-4ab3-aa70-549b28502951.jpg",
#       "extension"         =>"jpg",
#       "processedFiles"         =>         [
#         {
#           "width"               =>640,
#           "height"               =>640,
#           "url"               =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/640x640_4cace1a7-8979-4ab3-aa70-549b28502951.jpg"
#         },
#         {
#           "width"               =>320,
#           "height"               =>320,
#           "url"               =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/320x320_4cace1a7-8979-4ab3-aa70-549b28502951.jpg"
#         },
#         {
#           "width"               =>172,
#           "height"               =>172,
#           "url"               =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/172x172_4cace1a7-8979-4ab3-aa70-549b28502951.jpg"
#         },
#         {
#           "width"               =>84,
#           "height"               =>84,
#           "url"               =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/84x84_4cace1a7-8979-4ab3-aa70-549b28502951.jpg"
#         }
#       ],
#       "url"         =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/4cace1a7-8979-4ab3-aa70-549b28502951.jpg"
#     },
#     {
#       "ydistance_percent"         =>0.9982486963272095,
#       "id"         =>"71c61b85-89bd-405c-b2c5-bb46eeb501c3",
#       "xoffset_percent"         =>0,
#       "yoffset_percent"         =>0,
#       "xdistance_percent"         =>1,
#       "fileName"         =>"71c61b85-89bd-405c-b2c5-bb46eeb501c3.jpg",
#       "extension"         =>"jpg",
#       "processedFiles"         =>         [
#         {
#           "width"               =>640,
#           "height"               =>640,
#           "url"               =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/640x640_71c61b85-89bd-405c-b2c5-bb46eeb501c3.jpg"
#         },
#         {
#           "width"               =>320,
#           "height"               =>320,
#           "url"               =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/320x320_71c61b85-89bd-405c-b2c5-bb46eeb501c3.jpg"
#         },
#         {
#           "width"               =>172,
#           "height"               =>172,
#           "url"               =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/172x172_71c61b85-89bd-405c-b2c5-bb46eeb501c3.jpg"
#         },
#         {
#           "width"               =>84,
#           "height"               =>84,
#           "url"               =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/84x84_71c61b85-89bd-405c-b2c5-bb46eeb501c3.jpg"
#         }
#       ],
#       "url"         =>"http://images.gotinder.com/54a0604f8dd2e01c65229738/71c61b85-89bd-405c-b2c5-bb46eeb501c3.jpg"
#     }
#   ],
#   "birth_date_info"   =>"fuzzy birthdate active,
#  not displaying real birth_date"
# }
