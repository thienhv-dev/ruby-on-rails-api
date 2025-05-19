module Users
  class RegistrationsController < ApplicationController
    # POST /users (signup)
    def create
      @user = User.create!(user_params)

      render json: @user, serializer: UserSerializer, status: :created, location: @user
    end

    private

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end
  end
end
