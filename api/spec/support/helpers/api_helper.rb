# frozen_string_literal: true

module ApiHelper
  def default_request_headers(access_token)
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'Authorization' => "Bearer #{access_token.token}"
    }
  end
end
