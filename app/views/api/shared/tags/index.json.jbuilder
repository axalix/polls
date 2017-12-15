json.tags do
  json.array! @tags[:results], partial: 'tag', as: :tag
end

json.more @tags[:more]
