class Api::Main::Users::ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :authentication, only: [:show]

  # GET /api/users/confirmation
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      token = token = Services::Auth::Tokens.create(resource, request)
      render status: :ok, json: {token: token}
    else
      error_response :unprocessable_entity, resource.errors
    end
  end
end
