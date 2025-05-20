module Errors
  class DeviseUnauthorized
    # Initializes a new DeviseUnauthorized error instance.
    #
    # @param message [String] the error message describing the unauthorized access
    def initialize(message)
      @message = message
    end

    # Serializes the unauthorized error into a hash.
    #
    # @return [Hash] a hash containing the error type and message
    def to_hash
      {
        error: 'unauthorized',
        message: @message
      }
    end
  end
end