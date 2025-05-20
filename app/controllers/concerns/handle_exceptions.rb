module HandleExceptions
  extend ActiveSupport::Concern

  included do
    # Rescues from ActiveRecord::RecordInvalid exceptions and renders an unprocessable entity response.
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    # Rescues from ActionController::ParameterMissing exceptions and renders a parameter missing response.
    rescue_from ActionController::ParameterMissing, with: :render_parameter_missing_response

    # Rescues from ActiveRecord::RecordNotFound exceptions and renders a not found response.
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  end

  private

  # Renders a JSON response for unprocessable entity errors.
  #
  # @param error [ActiveRecord::RecordInvalid] the exception object containing the validation errors
  # @param status [Symbol] the HTTP status code to return (default: :unprocessable_entity)
  def render_unprocessable_entity_response(error, status: :unprocessable_entity)
    render json: Errors::ActiveRecordValidation.new(error.record).to_hash, status: status
  end

  # Renders a JSON response for not found errors.
  #
  # @param error [ActiveRecord::RecordNotFound] the exception object containing the not found error details
  # @param status [Symbol] the HTTP status code to return (default: :not_found)
  def render_not_found_response(error, status: :not_found)
    render json: Errors::ActiveRecordNotFound.new(error).to_hash, status: status
  end

  # Renders a JSON response for missing parameter errors.
  #
  # @param error [ActionController::ParameterMissing] the exception object containing the missing parameter details
  # @param status [Symbol] the HTTP status code to return (default: :unprocessable_entity)
  def render_parameter_missing_response(error, status: :unprocessable_entity)
    render json: Errors::ParameterMissing.new(error).to_hash, status: status
  end
end