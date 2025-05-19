class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update, :destroy, :followers, :following]

  def index
    users = User.all
    render json: users, each_serializer: UserSerializer, status: :ok
  end

  def show
    render json: @user, serializer: UserSerializer, status: :ok
  end

  def update
    @user.update!(user_params)
    render json: @user, serializer: UserSerializer, status: :ok
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def profile
    render json: current_user, serializer: UserProfileSerializer, status: :ok
  end

  def followers
    render json: @user.followers, each_serializer: UserSerializer, status: :ok
  end

  def following
    render json: @user.following, each_serializer: UserSerializer, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
