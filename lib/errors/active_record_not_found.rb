module Errors
  class ActiveRecordNotFound < Errors::ApplicationError
    attr_reader :model, :field, :detail, :message_key

    # Initializes a new ActiveRecordNotFound error instance.
    #
    # @param error [ActiveRecord::RecordNotFound]
    # @param message [Symbol, String, nil]
    def initialize(error, message: nil)
      @model = error.model.underscore
      @detail = error.class.to_s.split("::")[1].underscore
      @field = error.primary_key
      @message_key = message || :default
      @errors = serialize
    end

    # Serializes the not found error into an array of hashes.
    #
    # @return [Array<Hash>]
    def serialize
      [
        {
          resource: resource,
          field: field,
          code: code,
          message: message
        }
      ]
    end

    private

    # Translates the error message using I18n.
    #
    # @return [String]
    def message
      I18n.t message_key,
             scope: [:api, :errors, :messages, :not_found],
             resource: resource
    end

    # Translates the resource name using I18n.
    #
    # @return [String]
    def resource
      I18n.t model,
             locale: :api,
             scope: [:api, :errors, :resources],
             default: model
    end

    # Translates the error detail or code using I18n.
    #
    # @return [String]
    def code
      I18n.t detail,
             locale: :api,
             scope: [:api, :errors, :code],
             default: detail
    end
  end
end