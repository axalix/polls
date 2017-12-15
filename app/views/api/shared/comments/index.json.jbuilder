json.comments do
  json.array! @comments[:results], partial: 'comment', as: :comment
end

json.more @comments[:more]
