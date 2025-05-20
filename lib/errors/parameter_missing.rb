module Errors
  class ParameterMissing < Errors::ApplicationError
    # @return [Symbol, String] the name of the missing parameter
    attr_reader :param

    # Initializes a new ParameterMissing error instance.
    #
    # @param exception [ActionController::ParameterMissing] the original exception object
    def initialize(exception)
      @param = exception.param
      @message = exception.message
    end

    # Serializes the missing parameter error into a hash.
    #
    # @return [Hash] a hash containing the error type, message, and missing parameter
    def to_hash
      {
        error: 'parameter_missing',
        message: @message,
        missing_param: @param
      }
    end
  end
end