# frozen_string_literal: true

module RecipeSearches
  module GroqActions
    class RecipeConfirmer < RecipeBaseAction
      # The most accurate (least “creative”) response is provided by a temperature of around 0.0.
      TEMPERATURE = 0
      POSITIVE_ANSWER = 'YES'

      # @return [Boolean]
      def call
        groq_question = generate_groq_question
        answer = groq_client.ask_question(question: groq_question)
        answer.eql?(POSITIVE_ANSWER)
      end

      private

      def temperature = TEMPERATURE

      def generate_groq_question
        ::GroqQuestionTemplates.confirm_text_is_real_recipe(probable_recipe_text: @recipe_search.answer)
      end
    end
  end
end
