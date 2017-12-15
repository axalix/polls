class Api::Main::Users::PasswordsController < DeviseController
  skip_before_filter :authentication, only: [:create, :update]
  before_filter :user_with_password, only: [:create]

  # POST /api/users/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render nothing: true, status: :created
    else
      respond_with resource
    end
  end

  # PUT /api/users/password
  def update
    api_user_params = params.require(:api_user)
    api_user_params.require(:reset_password_token)
    api_user_params.require(:password)
    api_user_params.require(:password_confirmation)

    self.resource = resource_class.reset_password_by_token(api_user_params)
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      token = Services::Auth::Tokens.create(resource, request)
      render status: :ok, json: {token: token}
    else
      respond_with resource
    end
  end

  protected

    # Check if proper Lockable module methods are present & unlock strategy
    # allows to unlock resource on password reset
    def unlockable?(resource)
      resource.respond_to?(:unlock_access!) &&
          resource.respond_to?(:unlock_strategy_enabled?) &&
          resource.unlock_strategy_enabled?(:email)
    end

    def user_with_password(email = nil)
      User.find_by! email: email || resource_params[:email], provider: nil
    end
end
