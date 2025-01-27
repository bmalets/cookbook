# frozen_string_literal: true

module Api
  module ErrorRespondable
    API_ERRORS = Rails.application.config_for(:api_errors).freeze

    def json_error_response(error_code, message = nil)
      error = API_ERRORS.fetch(error_code)
      error_message = message.presence || error.fetch(:default_message)

      render json: { error: error_message, code: error_code }, status: error.fetch(:http_code)
    end
  end
end
