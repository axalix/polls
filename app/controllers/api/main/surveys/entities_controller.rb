class Api::Main::Surveys::EntitiesController < Api::Controller
  before_filter :fetch_survey
  before_filter :fetch_survey_entity, only: [:destroy]

  def index
    @survey_entities = scoped_survey_entities
  end

  def create
    survey_entity = construct_survey_entity
    if survey_entity.save
      render status: :created, json: { id: survey_entity.id }
    else
      error_response :unprocessable_entity, survey_entity.errors
    end
  end

  def destroy
    if @survey_entity.destroy!
      render nothing: true, status: :ok
    else
      error_response :unprocessable_entity, @survey_entity.errors
    end
  end

  protected

  def construct_survey_entity
    se = SurveyEntity.new
    se.survey = @survey
    if @survey.kind == 'text'
      se.attributes = text_survey_entity_params
    elsif @survey.kind == 'photo'
      se.attributes = photo_survey_entity_params
    end
    se
  end

  def fetch_survey
    @survey = current_user.surveys.visible.find params[:id]
  end

  def fetch_survey_entity
    @survey_entity = @survey.survey_entities.find params[:survey_entity_id]
  end

  def text_survey_entity_params
    entity_params = params.require(:survey_entity)
    entity_params.require(:text)
    entity_params.permit!
  end

  def photo_survey_entity_params
    entity_params = params.require(:survey_entity)
    entity_params.require(:image_id)
    entity_params.permit!
  end

  def scoped_survey_entities
    @survey.survey_entities
  end
end
