module Errors
  # Base class for custom application errors.
  class ApplicationError < StandardError
    attr_reader :code, :message

    # Initializes
    #
    # @param code [String, nil]
    # @param message [String, nil]
    def initialize(code: nil, message: nil)
      @code, @message = code, message
    end

    # Serializes the error into an array of hashes.
    #
    # @return [Array<Hash>]
    def serialize
      [
        { code: code, message: message }
      ]
    end

    # Converts the error into a hash representation.
    #
    # @return [Hash]
    def to_hash
      {
        success: false,
        errors: serialize
      }
    end
  end
end