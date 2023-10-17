RSpec.describe Api::V1::SessionsController, type: :controller do
  describe "#create" do
    let(:user) { FactoryBot.create(:user, username: "test-user", password: "test-pwd") }
    let(:param_username) { user.username }
    let(:param_password) { user.password }
    let(:params) { {user: {username: param_username, password: param_password}} }

    before :each do
      user
      post :create, params: params
      @body = JSON.parse(response.body)
    end

    it "responds with an auth token for the user session, along with user details" do
      expect(response).to have_http_status(201)
      expect(@body.keys.sort).to eq(["jwt", "user"])

      decode_response = AuthTokenDecoder.call(token: @body["jwt"])
      expect(decode_response.success?).to be true
      expect(decode_response.content.first.keys.sort).to eq(["exp", "user_id"])
      expect(decode_response.content.first["user_id"]).to eq(user.id)

      expect(@body["user"].keys.sort).to eq(["attributes", "id", "type"])
      expect(@body["user"]["attributes"].keys).to eq(["username"])
      expect(@body["user"]["attributes"]["username"]).to eq("test-user")
      expect(@body["user"]["id"]).to eq(user.id)
      expect(@body["user"]["type"]).to eq("user")
    end

    context "with an incorrect password param" do
      let(:param_password) { "INCORRECT_PASSWORD" }

      it "reponds with a Login Failed error message" do
        expect(response).to have_http_status(401)
        expect(@body.keys.sort).to eq(["error"])
        expect(@body["error"]).to eq("Login Failed")
      end
    end

    context "with a username param that is not in the database" do
      let(:param_username) { "NONEXISTENT_USERNAME" }

      it "reponds with a Login Failed error message" do
        expect(response).to have_http_status(401)
        expect(@body.keys.sort).to eq(["error"])
        expect(@body["error"]).to eq("Login Failed")
      end
    end

    context "with missing parameters" do
      let(:params) { {user: {username: param_username}} }

      it "reponds with a Login Failed error message" do
        expect(response).to have_http_status(401)
        expect(@body.keys.sort).to eq(["error"])
        expect(@body["error"]).to eq("Login Failed")
      end
    end
  end
end
