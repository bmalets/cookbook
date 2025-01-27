# frozen_string_literal: true

module System
  class RemoveInactiveRecipeSearchesJob < ApplicationJob
    sidekiq_options retry: false

    def perform
      RecipeSearch.inactive_since(cut_off_date).destroy_all
    end

    private

    def cut_off_date
      ENV.fetch('REMOVE_INACTIVE_RECIPE_SEARCHES_AFTER_IN_DAYS').days.ago
    end
  end
end
