# frozen_string_literal: true

class ApiController < ActionController::API
  include Api::ErrorRespondable
  include Api::ErrorHandlable
end
