# frozen_string_literal: true

Doorkeeper.configure do
  orm :active_record
  api_only
  access_token_expires_in 10.days
  base_controller 'ActionController::API'
  use_refresh_token
  client_credentials :from_params
  access_token_methods :from_bearer_authorization
  handle_auth_errors :raise
  default_scopes :read
  optional_scopes :write
  grant_flows %w[client_credentials]
end
