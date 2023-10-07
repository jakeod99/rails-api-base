class AuthTokenDecoder < ApplicationService
  def initialize(token:)
    @token = token
  end

  def call
    decoded_token = decode_token
    return failure decoded_token if decoded_token.first[:error].present?
    success decoded_token
  end

  private

  def secret_jwt_key
    Rails.application.credentials.secret_jwt_key
  end

  def decode_token
    begin
      JWT.decode(
        @token, 
        secret_jwt_key, 
        true, 
        { algorithm: ENV['JWT_ALGORITHM'] || AuthTokenIssuer::DEFAULT_JWT_ALGORITHM }
      )
    rescue JWT::DecodeError
      [ { error: "Invalid Token" } ]
    end
  end
end
