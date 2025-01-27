# frozen_string_literal: true

module Api
  module V1
    module RecipeSearches
      class StatusSerializer
        include FastJsonapi::ObjectSerializer

        attributes :status
      end
    end
  end
end
