# frozen_string_literal: true

module RecipeSearches
  module GroqActions
    class RecipeFinder < RecipeBaseAction
      # Level of "creativity" is generally quite creative, yet not chaotic
      TEMPERATURE = 0.7

      # @return [String]
      def call
        groq_question = generate_groq_question
        groq_client.ask_question(question: groq_question)
      end

      private

      def temperature = TEMPERATURE

      def generate_groq_question
        ::GroqQuestionTemplates.find_receipt_by_ingredients(ingredients: @recipe_search.ingredients)
      end
    end
  end
end
