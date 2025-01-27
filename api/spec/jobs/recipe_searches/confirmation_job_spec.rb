# frozen_string_literal: true

require 'rails_helper'

describe RecipeSearches::ConfirmationJob do
  describe '#perform' do
    subject(:perform_job) { described_class.perform_now(recipe_search.id) }

    let(:recipe_search) do
      create(:recipe_search, :pending_confirmation, answer: recipe_content.strip_heredoc)
    end

    let(:recipe_content) do
      <<~RECIPE
        Here's a delicious recipe using your ingredients:

        Apple and Avocado Salad

        Ingredients:
        - 2 sweet apples, diced
        - 2 ripe avocados, cubed
        - 1 tablespoon lemon juice
        - 2 tablespoons olive oil
        - Salt and pepper to taste

        Instructions:
        1. Combine diced apples and cubed avocados in a bowl
        2. Drizzle with lemon juice and olive oil
        3. Season with salt and pepper
        4. Toss gently and serve immediately
      RECIPE
    end

    context 'when the recipe confirmation is successful' do
      it 'marks the recipe search as confirmed', :vcr do
        expect { perform_job }
          .to change { recipe_search.reload.status }
          .from('pending_confirmation')
          .to('confirmed')
      end
    end

    context 'when the recipe confirmation is not successful' do
      let(:recipe_content) do
        <<~RECIPE
          It is not recipe.
        RECIPE
      end

      it 'marks the recipe search as confirmation failed', :vcr do
        expect { perform_job }
          .to change { recipe_search.reload.status }
          .from('pending_confirmation')
          .to('confirmation_failed')
      end
    end

    context 'when confirmation raises an error' do
      it 'marks the recipe search as confirmation error and raises the error', :vcr do
        expect { perform_job }
          .to change { recipe_search.reload.status }
          .from('pending_confirmation')
          .to('confirmation_error')
          .and raise_error(Faraday::Error, 'the server responded with status 500')
      end
    end
  end
end
