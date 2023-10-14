RSpec.describe AuthTokenDecoder do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:token) { AuthTokenIssuer.call(user_id: user.id).content }
  let(:env_jwt_algorithm) { "HS512" }
  let(:default_jwt_algorithm) { AuthTokenIssuer::DEFAULT_JWT_ALGORITHM }
  let(:jwt_expiry) { AuthTokenIssuer::DEFAULT_JWT_EXPIRY }

  before :example do |test|
    unless test.metadata[:skip_env_stubs]
      stub_const(
        "ENV",
        ENV.to_hash.merge(
          "JWT_ALGORITHM" => env_jwt_algorithm.to_s
        )
      )
    end
  end

  subject { AuthTokenDecoder.call(token: token) }

  describe "#call" do
    it "responds with the decoded token" do
      travel_to Time.now do
        response = subject
        expect(response.success?).to be true
        expect(response.content.first["exp"]).to eq(Time.now.to_i + jwt_expiry)
        expect(response.content.first["user_id"]).to eq user.id
        expect(response.content.second["alg"]).to eq env_jwt_algorithm
      end
    end

    context "when the token has expired" do
      it "repsonds with an Invalid Token error" do
        token
        travel_to 2.days.from_now do
          response = subject
          expect(response.success?).to be false
          expect(response.content.first[:error]).to eq "Invalid Token"
        end
      end
    end

    context "when no JWT algorithm is specified in ENV" do
      it "responds with the decoded token using the default algorithm", skip_env_stubs: true do
        travel_to Time.now do
          response = subject
          expect(response.success?).to be true
          expect(response.content.first["exp"]).to eq(Time.now.to_i + jwt_expiry)
          expect(response.content.first["user_id"]).to eq user.id
          expect(response.content.second["alg"]).to eq default_jwt_algorithm
        end
      end
    end
  end
end
