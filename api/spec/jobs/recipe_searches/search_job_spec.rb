# frozen_string_literal: true

require 'rails_helper'

describe RecipeSearches::SearchJob do
  describe '#perform' do
    subject(:perform_job) { described_class.perform_now(recipe_search.id) }

    let(:recipe_search) { create(:recipe_search, :requested_search, ingredients: %w[apple avocado]) }

    context 'when the recipe search is successful' do
      it 'processes the recipe search and enqueues confirmation', :vcr do
        expect { perform_job }
          .to change { recipe_search.reload.status }.from('pending_search').to('pending_confirmation')
          .and have_enqueued_job(RecipeSearches::ConfirmationJob).with(recipe_search.id)
      end

      it 'saves the recipe answer from Groq', :vcr do
        perform_job
        expect(recipe_search.reload.answer).to be_present
      end
    end

    context 'when search raises an error' do
      it 'marks the recipe search as search error and raises the error', :vcr do
        expect { perform_job }
          .to change { recipe_search.reload.status }
          .from('pending_search')
          .to('search_error')
          .and raise_error(Faraday::Error, 'the server responded with status 500')
      end
    end
  end
end
