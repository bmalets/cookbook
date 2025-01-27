# frozen_string_literal: true

module Api
  module V1
    module RecipeSearches
      class AnswerSerializer
        include FastJsonapi::ObjectSerializer

        attributes :answer
      end
    end
  end
end
