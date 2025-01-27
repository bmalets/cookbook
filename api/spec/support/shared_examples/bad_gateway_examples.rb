# frozen_string_literal: true

shared_examples 'bad gateway response' do
  it 'returns bad gateway status' do
    expect(response).to have_http_status(:bad_gateway)
  end

  it 'returns JSON content type' do
    expect(response.content_type).to match(%r{application/json})
  end

  it 'returns appropriate error message' do
    expect(response.parsed_body).to include(
      'error' => 'Sorry, we couldn\'t reach an external service. Please try again later.',
      'code' => 'llm_service_unavailable'
    )
  end
end
