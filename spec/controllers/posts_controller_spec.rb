require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::Test::ControllerHelpers
  # include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user) }
  let!(:post_record) { create(:post, title: "Test Title", content: "Test content", user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a list of posts" do
      get :index
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_a(Hash)
      expect(json).to have_key("posts")
      expect(json["posts"]).to be_an(Array)
      expect(json["posts"]).not_to be_empty

      matching_post = json["posts"].find { |p| p["id"] == post_record.id }
      expect(matching_post).not_to be_nil
      expect(matching_post["title"]).to eq(post_record.title)
    end
  end

  describe "GET #show" do
    context "when the post exists" do
      it "returns the post" do
        get :show, params: { id: post_record.id }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json).to have_key("post")
        expect(json["post"]).to include(
          "id" => post_record.id,
          "title" => post_record.title,
          "content" => post_record.content
        )
      end
    end

    context "when the post does not exist" do
      it "returns not found" do
        get :show, params: { id: 0 }

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json["success"]).to eq(false)
        expect(json["errors"]).to be_an(Array)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new post" do
        expect {
          post :create, params: { post: { title: "New Post", content: "New content" } }
        }.to change(Post, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["post"]).to include(
                                  "title" => "New Post",
                                  "content" => "New content"
                                )
        expect(json["post"]["user"]["id"]).to eq(user.id)
      end
    end

    context "with invalid params" do
      it "returns unprocessable_entity with errors" do
        post :create, params: { post: { title: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(false)
        expect(json["errors"]).to be_an(Array)
      end
    end
  end

  describe "PATCH #update" do
    context "when not logged in" do

      before do
        sign_out(:user)  # chắc chắn user chưa đăng nhập
      end

      it "returns unauthorized status" do

        patch :update, params: { id: post_record.id, post: { title: "Updated Title" } }

        expect(response).to have_http_status(:unauthorized)
        # Nếu API trả json lỗi, có thể check thêm
        # expect(json["error"]).to be_present
      end
    end

    context "with valid params" do
      it "updates the post" do
        patch :update, params: { id: post_record.id, post: { title: "Updated Title" } }

        expect(response).to have_http_status(:ok)
        expect(post_record.reload.title).to eq("Updated Title")

        json = JSON.parse(response.body)
        expect(json["post"]["title"]).to eq("Updated Title")
      end
    end

    context "with invalid params" do
      it "returns validation error" do
        patch :update, params: { id: post_record.id, post: { title: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(false)
        expect(json["errors"]).to be_an(Array)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the post" do
      expect {
        delete :destroy, params: { id: post_record.id }
      }.to change(Post, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(Post.find_by(id: post_record.id)).to be_nil
    end
  end
end
