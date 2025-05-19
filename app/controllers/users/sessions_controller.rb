# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opt = {})
    @token = request.env['warden-jwt_auth.token']
    headers['Authorization'] = @token

    user_data = ActiveModelSerializers::SerializableResource.new(resource, serializer: UserSerializer).as_json

    render json: {
      success: true,
      token: @token,
      data: user_data
    }, status: :ok
  end

  def respond_to_on_destroy
    sign_out(current_user)
    render json: {
      success: true,
      status: {
        code: 200, message: 'Logged out successfully.'
      }
    }, status: :ok
  end
end
