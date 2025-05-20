require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            name: "Test User",
            email: "test_#{SecureRandom.hex(4)}@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end

      it "creates a new user" do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["user"]["email"]).to eq(valid_params[:user][:email])
        expect(json["user"]["name"]).to eq(valid_params[:user][:name])
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            name: "",
            email: "",
            password: "pass",
            password_confirmation: "wrong"
          }
        }
      end

      it "does not create a user and returns errors" do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json["errors"]).to be_an(Array)
      end
    end
  end
end
