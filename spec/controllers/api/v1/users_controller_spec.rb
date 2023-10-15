RSpec.describe Api::V1::UsersController, type: :controller do
  describe "#create" do
    let(:preexisting_user) { nil }
    let(:param_username) { "test-user" }
    let(:param_password) { "test-pwd" }
    let(:params) { {user: {username: param_username, password: param_password}} }

    before :each do
      preexisting_user
      post :create, params: params
      @body = JSON.parse(response.body)
    end

    it "responds with the newly created user's details, along with a session auth token" do
      expect(response).to have_http_status(201)
      expect(@body.keys.sort).to eq(["jwt", "user"])

      decode_response = AuthTokenDecoder.call(token: @body["jwt"])
      expect(decode_response.success?).to be true
      expect(decode_response.content.first.keys.sort).to eq(["exp", "user_id"])

      expect(@body["user"].keys.sort).to eq(["attributes", "id", "type"])
      expect(@body["user"]["attributes"].keys).to eq(["username"])
      expect(@body["user"]["attributes"]["username"]).to eq("test-user")
      expect(@body["user"]["type"]).to eq("user")

      expect(@body["user"]["id"].to_i).to eq(decode_response.content.first["user_id"])

      expect(User.exists?(username: param_username)).to be true
    end

    context "when username is already taken" do
      let(:preexisting_user) { FactoryBot.create(:user, **params[:user]) }

      it "reponds with a Failed to Create Valid User error message" do
        expect(response).to have_http_status(400)
        expect(@body.keys.sort).to eq(["error"])
        expect(@body["error"]).to eq("Failed to Create Valid User")
        expect(User.exists?(username: param_username)).to be true
      end
    end

    context "when username doesn't pass validation" do
      let(:param_username) { "lol" }

      it "reponds with a Failed to Create Valid User error message" do
        expect(response).to have_http_status(400)
        expect(@body.keys.sort).to eq(["error"])
        expect(@body["error"]).to eq("Failed to Create Valid User")
        expect(User.exists?(username: param_username)).to be false
      end
    end

    context "when password doesn't pass validation" do
      context "because it is too short" do
        let(:param_password) { "2short" }

        it "reponds with a Failed to Create Valid User error message" do
          expect(response).to have_http_status(400)
          expect(@body.keys.sort).to eq(["error"])
          expect(@body["error"]).to eq("Failed to Create Valid User")
          expect(User.exists?(username: param_username)).to be false
        end
      end

      context "because it is too long" do
        let(:param_password) do
          ("X" * ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED) + "-too-long!!!"
        end

        it "reponds with a Failed to Create Valid User error message" do
          expect(response).to have_http_status(400)
          expect(@body.keys).to eq(["error"])
          expect(@body["error"]).to eq("Failed to Create Valid User")
          expect(User.exists?(username: param_username)).to be false
        end
      end
    end
  end

  describe "#show" do
    let(:user) { FactoryBot.create(:user, username: "test-user", password: "test-pwd") }
    let(:user_id) { user.id }

    before :each do
      allow(controller).to receive(:authorize).and_return(nil)
      get :show, params: {id: user_id}
      @body = JSON.parse(response.body)
    end

    it "responds with the correct user" do
      expect(response).to have_http_status(200)
      expect(@body.keys).to eq(["user"])
      expect(@body["user"].keys.sort).to eq(["attributes", "id", "type"])
      expect(@body["user"]["attributes"].keys).to eq(["username"])
      expect(@body["user"]["attributes"]["username"]).to eq("test-user")
      expect(@body["user"]["id"]).to eq(user_id.to_s)
      expect(@body["user"]["type"]).to eq("user")
    end

    context "when requested user does not exist" do
      let(:user_id) { (User.last&.id || 0) + 1 }

      it "responds with Failed to Find User error message" do
        expect(response).to have_http_status(404)
        expect(@body.keys).to eq(["error"])
        expect(@body["error"]).to eq("Failed to Find User")
      end
    end
  end
end
