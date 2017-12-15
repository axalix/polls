class Api::Main::Surveys::SurveysController < Api::Controller
  before_filter :fetch_survey, only: [:show, :start, :stop, :results, :destroy]

  def index
    @surveys = scoped_surveys
  end

  def show
  end

  def results
  end

  def create
    survey = construct_survey
    if survey.save
      render status: :created, json: {id: survey.id}
    else
      error_response :unprocessable_entity, survey.errors
    end
  end

  def destroy
    if @survey.deactivate!
      render nothing: true, status: :ok
    else
      error_response :unprocessable_entity, @survey.errors
    end
  end

  def start
    if @survey.validate_and_activate!
      render nothing: true, status: :ok
    else
      error_response :unprocessable_entity, @survey.errors
    end
  end

  def stop
    if @survey.stop!
      render nothing: true, status: :ok
    else
      error_response :unprocessable_entity, @survey.errors
    end
  end

  protected

  def construct_survey
    s = Survey.new(survey_params)
    s.user = current_user
    s
  end

  def fetch_survey
    @survey = current_user.surveys.visible.find params[:id]
  end

  def survey_params
    params.require(:survey).permit([:kind])
  end

  def scoped_surveys
    current_user.surveys.visible
  end
end
