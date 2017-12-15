class Api::Main::Users::FacebookController < Api::Controller
  skip_before_filter :authentication, only: [:connect]

  rescue_from Koala::Facebook::AuthenticationError, with: :handle_auth_error

  def connect
    user  = connected_user
    token = create_user_token(user)
    render status: :ok, json: {token: token}
  end

  def handle_auth_error(exception)
    error_response :unauthorized, 'Facebook authorization problem: ' + exception.message.to_s
  end

  protected

  def fb_params
    params.require(:api_user).permit(:fb_user_id, :fb_token)
  end

  def fb_profile_by_fb_token(fb_token)
    graph = Koala::Facebook::API.new(fb_token)
    Hashie::Mash.new graph.get_object('me')
  end

  def connected_user
    # TODO: what if user is banned?
    fb_user_profile = fb_profile_by_fb_token(fb_params[:fb_token])
    raise AccessDenied, 'Invalid Facebook credentials' if fb_user_profile.id != fb_params[:fb_user_id]
    user = User.find_by provider: 'facebook', provider_user_id: fb_user_profile.id
    user = create_user!(fb_user_profile) unless user
    user
  end

  def create_user_token(user)
    Services::Auth::Tokens.create(user, request)
  end

  def create_user!(fb_user_profile)
    old_user = User.find_by provider: 'facebook', email: fb_user_profile.email
    raise AccessDenied, 'User with the same email already exists in the database' if old_user.present?

    user = User.new({
      provider:     'facebook',
      email:        fb_user_profile.email,
      provider_user_id:  fb_user_profile.id,
      password:     Devise.friendly_token[0, 20],
    })
    user.skip_confirmation!
    user.save!
    user
  end
end
