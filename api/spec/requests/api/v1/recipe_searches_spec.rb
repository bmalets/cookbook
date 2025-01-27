# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::RecipeSearches' do
  describe 'POST /api/v1/recipe_searches' do
    subject(:make_request) do
      post '/api/v1/recipe_searches',
           params: params.to_json,
           headers: default_request_headers(create(:doorkeeper_application_access_token, :web_app))
    end

    context 'with valid parameters' do
      let(:ingredients) { Array.new(3) { Faker::Food.ingredient } }
      let(:params) do
        {
          recipe_search: {
            ingredients: ingredients
          }
        }
      end

      it 'creates a new recipe search' do
        expect { make_request }.to change(RecipeSearch, :count).by(1)

        created_search = RecipeSearch.last
        expect(created_search.ingredients).to match_array(ingredients)
      end

      it 'returns created status' do
        make_request
        expect(response).to have_http_status(:created)
      end

      it 'returns JSON content type' do
        make_request
        expect(response.content_type).to match(%r{application/json})
      end
    end

    context 'with missing required parameters' do
      let(:params) { { recipe_search: {} } }

      it 'returns unprocessable_entity status' do
        make_request
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns JSON content type' do
        make_request
        expect(response.content_type).to match(%r{application/json})
      end

      it 'returns appropriate error message' do
        make_request
        expect(response.body).to include_json(
          error: 'recipe_search parameter is missing',
          code: 'required_parameter_missing'
        )
      end
    end

    context 'without recipe_search params' do
      let(:params) { {} }

      it 'returns bad_request status' do
        make_request
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns JSON content type' do
        make_request
        expect(response.content_type).to match(%r{application/json})
      end

      it 'returns appropriate error message' do
        make_request
        expect(response.body).to include_json(
          error: 'recipe_search parameter is missing',
          code: 'required_parameter_missing'
        )
      end
    end
  end
end
