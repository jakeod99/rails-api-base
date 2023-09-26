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

  def encoded_token
    JWT.encode(
      {
        user_id: @user_id,
        exp: (Time.now + ENV['JWT_EXPIRY'].to_i).to_i
      },
      secret_jwt_key,
      ENV['JWT_ALGORITHM']
    )
  end
end
