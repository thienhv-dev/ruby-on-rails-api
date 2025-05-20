require 'rails_helper'

RSpec.describe Users::FollowsController, type: :controller do
  describe "POST #create" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before { sign_in user }

    context "when following a user successfully" do
      it "adds the user to following list" do
        post :create, params: { id: other_user.id }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(true)
        expect(json["message"]).to eq("You followed #{other_user.email}")
        expect(user.following).to include(other_user)
      end
    end

    context "when the user is already followed" do
      before { user.following << other_user }

      it "does not duplicate follow and still returns success" do
        expect {
          post :create, params: { id: other_user.id }
        }.not_to change { user.following.count }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(true)
      end
    end

    context "when user to follow does not exist" do
      it "returns not found" do
        post :create, params: { id: -1 }

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(false)
        expect(json["errors"].first["resource"]).to eq("user")
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      user.following << other_user
      sign_in user
    end

    context "when unfollowing a user successfully" do
      it "removes the user from following list" do
        delete :destroy, params: { id: other_user.id }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(true)
        expect(json["message"]).to eq("You unfollowed #{other_user.email}")
        expect(user.following).not_to include(other_user)
      end
    end

    context "when unfollowing a non-existent user" do
      it "returns not found" do
        delete :destroy, params: { id: -999 }

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(false)
        expect(json["errors"].first["resource"]).to eq("user")
      end
    end
  end
end
