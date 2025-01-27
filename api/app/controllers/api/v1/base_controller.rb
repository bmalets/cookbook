# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApiController
      include Authorizable
    end
  end
end
