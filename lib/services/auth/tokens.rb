class Services::Auth::Tokens
  class << self
    def create(user, request)
      token = generate_hex64
      TOKENS.expire token, REDIS_CONF['token_life_minutes'].minutes.to_i
      TOKENS.set token, session_storage_for_user(user, request)
      token
    end

    def get_user(request)
      token = token_by_request(request)
      return nil unless token
      user_by_token(token)
    end

    def drop(token)
      TOKENS.del token
    end

    def drop_by_request(request)
      token = token_by_request(request)
      drop(token)
    end

    private

    def user_by_token(token)
      session = session_by_token(token)
      return unless session
      user_by_session(session)
    end

    def user_by_session(session)
      User.find(session['user_id'])
    end

    def session_by_token(token)
      raw_session = TOKENS.get(token)
      return nil unless raw_session
      JSON.parse(raw_session)
    end

    def session_storage_for_user(user, request)
      session_for_user(user, request).to_json
    end

    def session_for_user(user, request)
      {
        user_id: user.id
        # TODO: log info about number of requests, last usage date, last request, IP, user-agent and many others
      }
    end

    def generate_hex64
      SecureRandom.hex(64)
    end

    def token_by_request(request)
      request.headers['HTTP_AUTHORIZATION'] || nil
    end
  end
end
