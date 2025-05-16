require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let!(:post_record) { Post.create!(title: "Test", content: "Content") }

  describe "GET #index" do
    it "returns a success response when requesting the posts index" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns the post when the post exists" do
      get :show, params: { id: post_record.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns 404 not found when the post does not exist" do
      get :show, params: { id: 999999 }
      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json).to eq({ "error" => "Post not found" })
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new post and returns created status" do
        expect {
          post :create, params: { post: { title: "New", content: "More" } }
        }.to change(Post, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid attributes" do
      it "does not create a new post and returns unprocessable entity with errors" do
        expect {
          post :create, params: { post: { title: "", content: "" } }
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json).to include("title", "content")
      end
    end
  end

  describe "PATCH #update" do
    let!(:post_record) { Post.create!(title: "Original", content: "Something") }

    context "with valid parameters" do
      it "updates the post and returns success" do
        patch :update, params: { id: post_record.id, post: { title: "Updated" } }
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["title"]).to eq("Updated")
      end
    end

    context "with invalid parameters" do
      it "does not update the post and returns errors with unprocessable entity status" do
        patch :update, params: { id: post_record.id, post: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json).to include("title")
      end

      it "returns 404 not found when updating a non-existent post" do
        patch :update, params: { id: 999999 }
        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json).to eq({ "error" => "Post not found" })
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the post and returns no content status" do
      expect {
        delete :destroy, params: { id: post_record.id }
      }.to change(Post, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 not found when deleting a non-existent post" do
      delete :destroy, params: { id: 999999 }
      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json).to eq({ "error" => "Post not found" })
    end
  end
end
