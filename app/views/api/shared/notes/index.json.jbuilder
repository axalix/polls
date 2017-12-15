json.notes do
  json.array! @notes[:results], partial: 'note', as: :note
end

json.more @notes[:more]
