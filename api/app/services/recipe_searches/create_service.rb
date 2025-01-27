# frozen_string_literal: true

module RecipeSearches
  class CreateService < BaseService
    def initialize(attributes:)
      @attributes = attributes
      super
    end

    def call
      recipe_search = RecipeSearch.new(**@attributes, latest_activity_at: Time.current)
      return recipe_search unless recipe_search.save

      enqueue_search(recipe_search)
      recipe_search
    end

    private

    def enqueue_search(recipe_search)
      SearchJob.perform_later(recipe_search)
    end
  end
end
