module Errors
  class ActiveRecordValidation < Errors::ApplicationError
    attr_reader :record

    # Initializes a new ActiveRecordValidation error instance.
    #
    # @param record [Object]
    def initialize(record)
      @record = record
      @errors = serialize
    end

    # Serializes the validation errors into an array of hashes.
    #
    # @param full_messages [Boolean]
    # @return [Array<Hash>]
    def serialize(full_messages: true)
      messages = record.errors.to_hash(full_messages)

      record.errors.details.map do |field, details|
        detail = details.first[:error]
        message = messages[field].first
        ValidationErrorSerializer.new(record, field, detail, message).serialize
      end
    end
  end
end