class Api::Main::Users::AccountsController < Api::Controller

  def change_password
    if current_user.provider
      error_response :bad_request, "Password cannot be changed due to another provider" # FB User
      return
    end

    if current_user.update_with_password(change_password_params)
      render nothing: true, status: :created
    else
      respond_with current_user
    end
  end

  def change_password_params
    api_user_params = params.require(:api_user)
    api_user_params.require(:current_password)
    api_user_params.require(:password)
    api_user_params.require(:password_confirmation)
    api_user_params.permit!
  end
end