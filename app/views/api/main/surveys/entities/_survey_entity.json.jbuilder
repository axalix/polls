json.(survey_entity,
    :id,
    :text,
    :num_votes,
    :created_at
)

json.image do
  json.partial! jpath('image/survey_entity'), obj: survey_entity.image
end if survey_entity.image