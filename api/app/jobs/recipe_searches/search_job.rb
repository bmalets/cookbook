# frozen_string_literal: true

module RecipeSearches
  class SearchJob < BaseJob
    def perform(recipe_search_id)
      recipe_search = RecipeSearch.could_be_answered.find_by(id: recipe_search_id)
      return unless recipe_search

      search_and_save_recipe_answer!(recipe_search)
      enqueue_answer_confirmation(recipe_search)
    rescue StandardError => e
      recipe_search.mark_search_as_api_error!
      raise e
    end

    private

    def search_and_save_recipe_answer!(recipe_search)
      ApplicationRecord.transaction do
        recipe_search.start_searching!
        recipe_search.answer = recipe_answer(recipe_search)
        recipe_search.mark_search_as_succeeded!
      end
    end

    def enqueue_answer_confirmation(recipe_search)
      ConfirmationJob.perform_later(recipe_search.id)
    end

    def recipe_answer(recipe_search)
      GroqActions::RecipeFinder.call(recipe_search:)
    end
  end
end
