class ApplicationController < ActionController::API
  before_action :authorized

  JWT_ALGORITHM = 'HS256'
  JWT_EXPIRY = 3.hours # TODO - MOVE TO ENV / PARAMETER_STORE

  def jwt_key
    Rails.application.credentials.jwt_key
  end

  def issue_token(user)
    JWT.encode({ user_id: user.id, exp: (Time.now + JWT_EXPIRY).to_i }, jwt_key, JWT_ALGORITHM)
  end

  def decoded_token
    begin
      JWT.decode(token, jwt_key, true, { :algorithm => JWT_ALGORITHM })
    rescue JWT::DecodeError
      [ { error: "Invalid Token" } ]
    end
  end

  def authorized
    render json: { message: 'Invalid Authorization' }, status: :unauthorized unless logged_in?
  end

  def token
    request.headers['Authorization']
  end

  def user_id
    decoded_token.first['user_id']
  end

  def current_user
    @user ||= User.find_by(id: user_id)
  end

  def logged_in?
    !!current_user
  end
end
