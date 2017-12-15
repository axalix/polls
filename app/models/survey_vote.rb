class SurveyVote < ActiveRecord::Base
  belongs_to  :survey,        class_name: 'Survey'
  belongs_to  :survey_entity, class_name: 'SurveyEntity'
  belongs_to  :user,          class_name: 'User'

  validates_presence_of   :survey_id
  validates_presence_of   :survey_entity_id
  validates_presence_of   :user_id
  validates_uniqueness_of :survey_id, :scope => [:user_id]

  class << self
    def process!(survey, attr = {})
      entity = SurveyEntity.find_by(id: attr['survey_entity_id'], survey_id: survey.id)
      raise CustomError, "Couldn't find a SurveyEntity with 'id'=#{attr['survey_entity_id']} for Survey" unless entity.present?

      transaction do
        begin
          SurveyVote.create(attr.merge({survey: survey}))
          SurveyEntity.increment_counter(:num_votes, entity.id)
          Survey.increment_counter(:num_votes, survey.id)
          Survey.increment_counter(:public_votes_done, survey.id) if survey.publicity_status == 'public'
        end
      end
      true
    end
  end
end
