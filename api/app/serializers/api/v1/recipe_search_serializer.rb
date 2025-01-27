# frozen_string_literal: true

module Api
  module V1
    class RecipeSearchSerializer
      include FastJsonapi::ObjectSerializer

      attribute :ingredients
    end
  end
end
