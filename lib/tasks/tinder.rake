namespace :tb do
  namespace :tinder do
    desc 'collect users from Tinder'
    task add_tinder_users: :environment do
      fb_id     = '464891386855067'
      fb_token  = 'CAAGm0PX4ZCpsBAA1z6BAZCZBErXjTc1ZB2INOuufZBUSzVEvWlrM6bbBZBJWVH34IxSHkDcJ9LgUjUn3KdSTPa69evP7pafhEbA3wAgpyAPuv9C2CW9gXLcRl04vKgW2AxyxIuM9ADg86dOZA5oidgyH4YgSdyerohzCxhQer7coZCxKIcp2D9rXxNyngV2kEPr7ZBoTordkruFh2inDWVjVzZCiZBtyllkAZCUZD'
      tinder = Scrapers::Tinder.new(fb_id, fb_token)
      3.times do
        tinder.collect_users(script, self.method(:save_users))
        sleep 60 * 60 # 1 hour
      end
    end

    def script
      [
        {
          location:           :toronto_union_station,
          iterations_count:   35,
          scatter:            [-0.00599, +0.00599],
          ages_range:         [20, 33],
          gender_probability: {men: 0.4, women: 0.5, both: 0.1},
          delays_range_sec:   [5, 11],
          final_delay_sec:    [5 * 60, 10 * 60]
        },

        {
          location:           :toronto_rogers_centre,
          iterations_count:   35,
          scatter:            [-0.00299, +0.00299],
          ages_range:         [16, 30],
          gender_probability: {men: 0.5, women: 0.4, both: 0.1},
          delays_range_sec:   [7, 22],
          final_delay_sec:    [15 * 60, 25 * 60]
        },

        {
          location:           :toronto_eaton_centre,
          iterations_count:   35,
          scatter:            [-0.00699, +0.00699],
          ages_range:         [18, 40],
          gender_probability: {men: 0.3, women: 0.6, both: 0.1},
          delays_range_sec:   [6, 12],
          final_delay_sec:    [10 * 60, 15 * 60]
        },

        {
          location:           :toronto_bloor_yonge,
          iterations_count:   35,
          scatter:            [-0.00399, +0.00399],
          ages_range:         [15, 33],
          gender_probability: {men: 0.4, women: 0.5, both: 0.1},
          delays_range_sec:   [4, 10],
          final_delay_sec:    [3 * 60, 5 * 60]
        },

        {
          location:           :toronto_reference_library,
          iterations_count:   35,
          scatter:            [-0.00399, +0.00399],
          ages_range:         [15, 45],
          gender_probability: {men: 0.35, women: 0.55, both: 0.1},
          delays_range_sec:   [2, 7],
          final_delay_sec:    [40 * 60, 60 * 60]
        },

        {
          location:           :toronto_pearson_terminal_1,
          iterations_count:   35,
          scatter:            [-0.00499, +0.00499],
          ages_range:         [15, 45],
          gender_probability: {men: 0.3, women: 0.6, both: 0.1},
          delays_range_sec:   [3, 5],
          final_delay_sec:    [5 * 60, 10 * 60]
        },

        {
          location:           :toronto_pearson_terminal_3,
          iterations_count:   35,
          scatter:            [-0.00499, +0.00499],
          ages_range:         [15, 45],
          gender_probability: {men: 0.3, women: 0.6, both: 0.1},
          delays_range_sec:   [5, 12],
          final_delay_sec:    [40 * 60, 55 * 60]
        }
      ]
    end

    def save_users(request, users)

      users.each do |user|
        TinderProfile.create_with(
          uid:        user[:uid],
          name:       user[:name],
          bio:        user[:bio],
          birth_date: user[:birth_date],
          gender:     user[:gender],
          photo:      user[:photo],
          latitude:   request[:latitude],
          longitude:  request[:longitude],
          distance:   request[:distance],
          json:       user[:json]
        ).find_or_create_by(uid: user[:uid])
      end
    end
  end
end
