# frozen_string_literal: true

module Api
  module V1
    module RecipeSearches
      class BaseController < ::Api::V1::BaseController
        before_action :check_recipe_search_status!
        after_action :update_latest_activity!

        private

        def recipe_search
          @recipe_search ||= RecipeSearch.find(params[:recipe_search_id])
        end

        def update_latest_activity!
          recipe_search.update!(latest_activity_at: Time.current)
        end

        def check_recipe_search_status!
          return unless recipe_search.failed_status?

          json_error_response(:llm_service_unavailable)
        end
      end
    end
  end
end
