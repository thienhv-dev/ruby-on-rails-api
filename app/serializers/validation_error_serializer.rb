# Serializer for validation errors in the application.
class ValidationErrorSerializer
  # Initializes a new ValidationErrorSerializer instance.
  #
  # @param record [Object]
  # @param field [Symbol, String]
  # @param detail [Symbol, String]
  # @param message [String]
  def initialize(record, field, detail, message)
    @record = record
    @field = field
    @detail = detail
    @message = message
  end

  # Serializes the validation error into a hash.
  #
  # @return [Hash]
  def serialize
    {
      resource: resource,
      field: field,
      code: code,
      message: @message
    }
  end

  private

  # Retrieves the resource name in an underscored format and translates it.
  #
  # @return [String]
  def resource
    I18n.t underscored_resource_name,
           locale: :api,
           scope: [:api, :errors, :resources],
           default: underscored_resource_name
  end

  # Translates the field name associated with the validation error.
  #
  # @return [String]
  def field
    I18n.t @field,
           scope: [:api, :errors, :fields, underscored_resource_name],
           default: @field.to_s
  end

  # Translates the error detail or code.
  #
  # @return [String]
  def code
    I18n.t @detail,
           locale: :api,
           scope: [:api, :errors, :code],
           default: @detail.to_s
  end

  # Converts the record's class name to an underscored string.
  #
  # @return [String]
  def underscored_resource_name
    @record.class.to_s.gsub("::", "").underscore
  end
end