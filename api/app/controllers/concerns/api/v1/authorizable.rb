# frozen_string_literal: true

module Api
  module V1
    module Authorizable
      extend ActiveSupport::Concern

      included do
        before_action :doorkeeper_authorize!
      end
    end
  end
end
