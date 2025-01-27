# frozen_string_literal: true

module Api
  module V1
    class RecipeSearchesController < BaseController
      def create
        receipt_search = create_search!
        render json: serialized(receipt_search), status: :created
      end

      private

      def create_params
        params.require(:recipe_search).permit(ingredients: [])
      end

      def create_search!
        ::RecipeSearches::CreateService.new(attributes: create_params).call
      end

      def serialized(record)
        RecipeSearchSerializer.new(record).flat_serializable_hash
      end
    end
  end
end
