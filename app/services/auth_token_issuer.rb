class AuthTokenIssuer < ApplicationService
  DEFAULT_JWT_EXPIRY = 10800
  DEFAULT_JWT_ALGORITHM = "HS256"

  def initialize(user_id:)
    @user_id = user_id
  end

  def call
    return failure unless User.exists? @user_id
    success encoded_token
  end

  private

  def secret_jwt_key
    Rails.application.credentials.secret_jwt_key
  end

  def expiry
    length = ENV["JWT_EXPIRY"]&.to_i || DEFAULT_JWT_EXPIRY
    Time.now.to_i + length
  end

  def encoded_token
    JWT.encode(
      {
        user_id: @user_id,
        exp: expiry
      },
      secret_jwt_key,
      ENV["JWT_ALGORITHM"] || DEFAULT_JWT_ALGORITHM
    )
  end
end
