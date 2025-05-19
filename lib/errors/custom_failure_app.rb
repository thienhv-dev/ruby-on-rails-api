module Errors
  # Custom failure application class for handling Devise authentication failures.
  # Overrides the default Devise::FailureApp behavior to provide a JSON API response.
  class CustomFailureApp < Devise::FailureApp
    # Determines the response format for the failure.
    # Calls the `json_api_response` method to render a JSON response.
    def respond
      json_api_response
    end

    # Renders a JSON API response for authentication failures.
    # Sets the HTTP status to 401 (Unauthorized), the content type to JSON,
    # and the response body to a serialized unauthorized error message.
    def json_api_response
      self.status = 401
      self.content_type = 'application/json'
      self.response_body = Errors::DeviseUnauthorized.new(i18n_message).to_hash.to_json
    end
  end
end