json.(survey_entity,
    :id,
    :image_id,
    :text
)

json.image do
  json.partial! jpath('image/survey_entity'), obj: survey_entity.image
end if survey_entity.image