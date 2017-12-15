json.profiles do
  json.array! @tinder_profiles[:results], partial: 'tinder_profile', as: :tinder_profile
end

json.more @tinder_profiles[:more]

