class Api::Main::Users::AuthController < Devise::SessionsController
  skip_before_filter :authentication, only: [:create, :destroy]

  # POST /api/users/sign_in
  def create
    #self.resource = warden.authenticate!(auth_options) #?
    self.resource = warden.authenticate!(:scope => resource_name, :recall => 'new')
    sign_in(resource_name, resource)
    # Generate rails token
    token = Services::Auth::Tokens.create(resource, request)
    render status: :ok, json: {token: token}
  end

  # DELETE /api/users/sign_out
  def destroy
    Services::Auth::Tokens.drop_by_request(request)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    render status: :ok, nothing: true
  end
end
