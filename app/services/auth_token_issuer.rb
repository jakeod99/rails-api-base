class AuthTokenIssuer < ApplicationService
  def initialize(user_id:)
    @user_id = user_id
  end

  def call
    return failure unless user_exists?
    success encoded_token
  end

  private

  def user_exists?
    User.exists? @user_id
  end

  def secret_jwt_key
    Rails.application.credentials.secret_jwt_key
  end

  def expiry
    length = ENV['JWT_EXPIRY']&.to_i || 10800
    Time.now.to_i + length
  end

  def encoded_token
    JWT.encode(
      {
        user_id: @user_id,
        exp: expiry
      },
      secret_jwt_key,
      ENV['JWT_ALGORITHM'] || 'HS256'
    )
  end
end
