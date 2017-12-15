class Api::Main::Surveys::VotingsController < Api::Controller
  def all_public_surveys
    @surveys = fetch_all_public_surveys
  end

  def random_public_survey
    @survey = fetch_random_public_survey
    error_response :not_found, "Resource not found"  unless @survey.present?
  end

  def public_survey
    @survey = fetch_public_survey
    error_response :not_found, "Resource not found"  unless @survey.present?
  end

  def private_survey
    @survey = fetch_private_survey
    error_response :not_found, "Resource not found"  unless @survey.present?
  end

  def public_vote
    r = fetch_public_survey.vote! survey_vote_params
    if r
      render nothing: true, status: :created
    else
      error_response :unprocessable_entity, r.errors
    end
  end

  def private_vote
    r = fetch_private_survey.vote! survey_vote_params
    if r
      render nothing: true, status: :created
    else
      error_response :unprocessable_entity, r.errors
    end
  end

  protected

  def survey_vote_params
    survey_vote_params = params.require(:survey_vote)
    survey_vote_params.require(:survey_entity_id)
    survey_vote_params.permit!
    survey_vote_params.merge({
      user:       current_user,
      remote_ip:  request.remote_ip,
    })
  end

  def fetch_all_public_surveys
    Survey.public_for current_user
  end

  def fetch_random_public_survey
    Survey.public_for(current_user).random
  end

  def fetch_public_survey
    Survey.public_for(current_user).find params[:id]
  end

  def fetch_private_survey
    Survey.private_for(current_user).find_by! :url_hash => params[:url_hash]
  end
end
