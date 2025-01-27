# frozen_string_literal: true

module RecipeSearches
  class ConfirmationJob < BaseJob
    def perform(recipe_search_id)
      recipe_search = RecipeSearch.could_be_confirmed.find_by(id: recipe_search_id)
      return unless recipe_search

      verify_recipe_answer!(recipe_search)
    rescue StandardError => e
      recipe_search.mark_as_confirmation_api_error!
      raise e
    end

    private

    def verify_recipe_answer!(recipe_search)
      ApplicationRecord.transaction do
        recipe_search.start_confirmation!

        if valid_recipe?(recipe_search)
          recipe_search.mark_confirmation_as_succeeded!
        else
          recipe_search.mark_confirmation_as_failed!
        end
      end
    end

    def valid_recipe?(recipe_search)
      GroqActions::RecipeConfirmer.call(recipe_search:)
    end
  end
end
