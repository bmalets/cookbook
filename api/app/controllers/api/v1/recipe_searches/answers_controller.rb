# frozen_string_literal: true

module Api
  module V1
    module RecipeSearches
      class AnswersController < BaseController
        def show
          render json: serialized(recipe_search)
        end

        private

        def serialized(record)
          AnswerSerializer.new(record).flat_serializable_hash_without_id
        end
      end
    end
  end
end
