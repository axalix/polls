class Api::Main::Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authentication, only: [:create]

  # POST /api/users
  def create
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
      else
        expire_data_after_sign_in!
      end
      render nothing: true, status: :created
    else
      clean_up_passwords resource
      error_response :unprocessable_entity, resource.errors
    end
  end

  def sign_up_params
    api_user_params = params.require(resource_name)
    api_user_params.require(:email)
    api_user_params.require(:password)
    api_user_params.require(:password_confirmation)
    api_user_params.permit!
  end
end
