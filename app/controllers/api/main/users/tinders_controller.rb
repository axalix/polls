class Api::Main::Users::TindersController < Api::Controller

  def connect
    tinder_api = TinderApi::Client.new
    response = tinder_api.sign_in(fb_params[:fb_user_id], fb_params[:fb_token])
    raise AccessDenied, response.to_json if response['error']
    render status: :ok, json: response.to_json
  end

  def profiles
    @tinder_profiles = TinderProfile
    @tinder_profiles = @tinder_profiles.age_at_least(params[:age_min].to_i) if params[:age_min]
    @tinder_profiles = @tinder_profiles.age_no_more(params[:age_max].to_i) if params[:age_max]
    @tinder_profiles = @tinder_profiles.gender(params[:gender].to_i) if params[:gender]
    @tinder_profiles = paginate(@tinder_profiles, params)
  end

  protected

  def fb_params
    params.require(:tinder_user).permit(:fb_user_id, :fb_token)
  end
end
