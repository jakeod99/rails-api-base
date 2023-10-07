RSpec.describe AuthTokenIssuer do

  include ActiveSupport::Testing::TimeHelpers

  let(:user_id) do
    user = FactoryBot.create(:user)
    user.id
  end
  let(:env_jwt_expiry) { 500 }
  let(:env_jwt_algorithm) { 'HS512' }
  let(:default_jwt_expiry) { AuthTokenIssuer::DEFAULT_JWT_EXPIRY }
  let(:default_jwt_algorithm) { AuthTokenIssuer::DEFAULT_JWT_ALGORITHM }

  before :example do |test|
    unless test.metadata[:skip_env_stubs]
      stub_const(
        'ENV', 
        ENV.to_hash.merge(
          'JWT_EXPIRY' => env_jwt_expiry.to_s,
          'JWT_ALGORITHM' => env_jwt_algorithm.to_s
        )
      )
    end
  end

  describe '#call' do

    subject { AuthTokenIssuer.call(user_id: user_id) }

    it "responds with a valid JWT auth token for the provided user" do
      travel_to Time.now do
        response = subject
        expect(response.success?).to be true
        token = response.content
        decoded_token = AuthTokenDecoder.call(token: token).content
        expect(decoded_token.first["user_id"]).to eq user_id
        expect(decoded_token.first["exp"]).to eq(Time.now.to_i + env_jwt_expiry)
        expect(decoded_token.second["alg"]).to eq env_jwt_algorithm
      end
    end

    context "when provided user does not exist" do
      let(:user_id) { (User.last&.id || 0) + 1 }

      it "responds with a failed ServiceResponse" do
        response = subject
        expect(response.success?).to be false
        expect(response.content).to be_nil
      end
    end

    context "when no ENV variables are set" do

      it "uses default values to produce a valid JWT auth token", skip_env_stubs: true do
        travel_to Time.now do
          response = subject
          expect(response.success?).to be true
          token = response.content
          decoded_token = AuthTokenDecoder.call(token: token).content
          expect(decoded_token.first["user_id"]).to eq user_id
          expect(decoded_token.first["exp"]).to eq(Time.now.to_i + default_jwt_expiry)
          expect(decoded_token.second["alg"]).to eq default_jwt_algorithm
        end
      end
    end
  end

  describe '#expiry' do

    subject { AuthTokenIssuer.new(user_id: user_id) }

    it 'provides a date time integer set forward the amount of time specified in ENV' do
      travel_to Time.now do
        expect(subject.send(:expiry)).to eq(Time.now.to_i + env_jwt_expiry)
      end
    end

    context "when no ENV variables are set" do
      it 'provides a date time integer set forward with the default', skip_env_stubs: true do
        travel_to Time.now do
          expect(subject.send(:expiry)).to eq(Time.now.to_i + default_jwt_expiry)
        end
      end
    end
  end
end