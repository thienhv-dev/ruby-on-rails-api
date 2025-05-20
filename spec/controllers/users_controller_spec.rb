require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { create(:user, name: "Test User") }
  let!(:other_user) { create(:user, name: "Other User") }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a list of users" do
      get :index
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to have_key("users")
      expect(json["users"]).to be_an(Array)
      expect(json["users"].map { |u| u["id"] }).to include(user.id, other_user.id)
    end
  end

  describe "GET #show" do
    context "when user exists" do
      it "returns the user" do
        get :show, params: { id: other_user.id }
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["user"]).to include(
                                  "id" => other_user.id,
                                  "email" => other_user.email,
                                  "name" => other_user.name
                                )
      end
    end

    context "when user does not exist" do
      it "returns not found error" do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json).to include("success" => false)
        expect(json["errors"]).to be_an(Array)
        expect(json["errors"].first).to include(
                                          "field" => "id",
                                          "code" => 1100
                                        )
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the user" do
        patch :update, params: { id: user.id, user: { name: "Updated Name" } }
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["user"]["name"]).to eq("Updated Name")
        expect(user.reload.name).to eq("Updated Name")
      end
    end

    context "with missing parameters" do
      it "returns unprocessable entity" do
        patch :update, params: { id: user.id, user: {} }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json).to include("error" => "parameter_missing")
        expect(json).to include("missing_param" => "user")
      end
    end

    context "with invalid parameters" do
      it "returns validation error for invalid email" do
        patch :update, params: { id: user.id, user: { email: "invalid-email" } }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(false)
        expect(json["errors"]).to be_an(Array)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the user" do
      expect {
        delete :destroy, params: { id: other_user.id }
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(User.find_by(id: other_user.id)).to be_nil
    end
  end

  describe "GET #profile" do
    it "returns current user profile" do
      get :profile
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["user"]["id"]).to eq(user.id)
      expect(json["user"]["email"]).to eq(user.email)
    end
  end

  describe "GET #followers" do
    let!(:target_user) { create(:user) }
    let!(:follower) { create(:user) }

    before do
      follower.follow(target_user)
      sign_in target_user
    end

    it "returns followers of the user" do
      get :followers, params: { id: target_user.id }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to have_key("users")
      expect(json["users"].map { |u| u["id"] }).to include(follower.id)
    end
  end

  describe "GET #following" do
    let!(:target_user) { create(:user) }
    let!(:followed_user) { create(:user) }

    before do
      target_user.follow(followed_user)
      sign_in target_user
    end

    it "returns users followed by the user" do
      get :following, params: { id: target_user.id }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to have_key("users")
      expect(json["users"].map { |u| u["id"] }).to include(followed_user.id)
    end
  end
end
