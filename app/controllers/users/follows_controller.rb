module Users
  class FollowsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:create, :destroy]

    # POST /users/:id/follow
    def create
      current_user.following << @user unless current_user.following.exists?(@user.id)
      render json: { success: true, message: "You followed #{@user.email}" }
    end

    # DELETE /users/:id/unfollow
    def destroy
      current_user.following.destroy(@user)
      render json: { success: true, message: "You unfollowed #{@user.email}" }
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
