json.partial! 'survey', survey: @survey

# Associations
json.entities   @survey.survey_entities,    partial: 'survey_entity',  as: :survey_entity