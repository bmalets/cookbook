# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API V1 Recipe Searches Statuses' do
  describe 'GET /api/v1/recipe_searches/:id/status' do
    subject(:make_request) do
      get "/api/v1/recipe_searches/#{recipe_search.id}/status",
          headers: default_request_headers(create(:doorkeeper_application_access_token, :web_app))
    end

    let(:recipe_search) { create(:recipe_search, :confirmed_answer) }

    context 'when the recipe search exists' do
      before { make_request }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON content type' do
        expect(response.content_type).to match(%r{application/json})
      end

      it 'returns the recipe search status data' do
        expect(response.parsed_body).to include_json(
          status: recipe_search.status
        )
      end
    end

    context 'when the recipe search does not exist' do
      let(:recipe_search) { build(:recipe_search, id: 0) }

      before { make_request }

      it 'returns not found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns JSON content type' do
        expect(response.content_type).to match(%r{application/json})
      end
    end

    context 'when the recipe search has error status' do
      let(:recipe_search) { create(:recipe_search, status: :search_error) }

      before { make_request }

      include_examples 'bad gateway response'
    end
  end
end
