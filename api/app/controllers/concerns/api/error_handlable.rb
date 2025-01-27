# frozen_string_literal: true

module Api
  module ErrorHandlable
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::ConnectionNotEstablished,
                  PG::ConnectionBad do |_error|
        json_error_response(:database_connection_error)
      end

      rescue_from ActiveRecord::RecordNotFound do |_error|
        json_error_response(:resource_not_found)
      end

      rescue_from ActionController::ParameterMissing do |error|
        error_message = "#{error.param} parameter is missing"
        json_error_response(:required_parameter_missing, error_message)
      end

      rescue_from ActionController::UnpermittedParameters do |error|
        error_message = "Unpermitted parameter: #{error.params}"
        json_error_response(:unpermitted_parameter, error_message)
      end

      rescue_from AASM::InvalidTransition do |_error|
        json_error_response(:invalid_state_transition)
      end
    end
  end
end
