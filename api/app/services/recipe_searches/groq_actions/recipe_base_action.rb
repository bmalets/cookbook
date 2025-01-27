# frozen_string_literal: true

module RecipeSearches
  module GroqActions
    class RecipeBaseAction < BaseService
      # @param recipe_search [RecipeSearch]
      def initialize(recipe_search:)
        @recipe_search = recipe_search
        super
      end

      private

      def groq_client
        @groq_client ||= GroqApi::Client.new(temperature:)
      end

      def temperature
        raise NotImplementedError, 'Abstract method was called'
      end
    end
  end
end
