# frozen_string_literal: true

module RecipeSearches
  class BaseJob < ApplicationJob
    sidekiq_options retry: 3

    def perform
      raise NotImplementedError, 'Abstract method was called'
    end
  end
end
