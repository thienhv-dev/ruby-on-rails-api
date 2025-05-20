require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create (login)" do
    it "responds with JSON containing token and user data" do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('warden-jwt_auth.token').and_return("dummy.jwt.token")

      post :create, params: { user: { email: user.email, password: user.password } }, as: :json

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["success"]).to eq(true)
      expect(json["token"]).to eq("dummy.jwt.token")
      expect(json["data"]["user"]["id"]).to eq(user.id)
      expect(response.headers["Authorization"]).to eq("dummy.jwt.token")
    end
  end

  describe "DELETE #destroy (logout)" do
    before do
      sign_in user
    end

    it "responds with JSON success message" do
      delete :destroy, as: :json

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["success"]).to eq(true)
      expect(json["status"]["code"]).to eq(200)
      expect(json["status"]["message"]).to eq("Logged out successfully.")
    end
  end
end
