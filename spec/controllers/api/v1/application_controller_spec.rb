RSpec.describe Api::V1::ApplicationController, type: :controller do

  # ApplicationController does not have any routes
  # Each method must be tested using an anonymous controller to establish context around a route
  controller do
    def index
      render json: { message: "anonymous controller message" }
    end
  end

  describe '#logged_in?' do
    let(:user) { FactoryBot.create(:user) }

    before :each do
      allow(subject).to receive(:current_user).and_return(user)
      get :index
    end

    context 'when logged in' do
      it 'returns true' do
        expect(subject.logged_in?).to be true
      end
    end

    context 'when not logged in' do
      let(:user) { nil }

      it 'returns false' do
        expect(subject.logged_in?).to be false
      end
    end
  end

  describe '#current_user' do
    let(:user) { FactoryBot.create(:user) }
    let(:token) { AuthTokenIssuer.call(user_id: user.id).content }

    before :each do
      request.headers.merge!({ "Authorization" => token })
      get :index
    end

    context 'when the request Authorization Token is valid' do
      it 'responds with the user that matches the token' do
        expect(subject.current_user).to eq(user)
      end
    end

    context 'when the request Authorization Token is invalid' do
      let(:token) { 'invalid-token-value' }

      it 'responds with nil' do
        expect(subject.current_user).to eq(nil)
      end
    end
  end

  describe '#authorize as a controller before_action' do
    controller do
      before_action :authorize
      def index
        render json: { message: "anonymous controller message" }
      end
    end

    context 'when not logged in' do
      before :each do
        allow(subject).to receive(:logged_in?).and_return(false)
        get :index
      end

      it 'responds with an Invalid Authorization message' do
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq("Invalid Authorization")
      end
    end

    context 'when logged in' do
      before :each do
        allow(subject).to receive(:logged_in?).and_return(true)
        get :index
      end

      it 'responds with an Invalid Authorization message' do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['message']).to eq("anonymous controller message")
      end
    end
  end
end
