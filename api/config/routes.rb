# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  if Rails.env.local?
    require 'sidekiq/web'
    require 'sidekiq-scheduler/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper scope: 'api/oauth' do
    skip_controllers :applications, :authorized_applications, :authorizations
  end

  namespace :api do
    namespace :v1 do
      resources :recipe_searches, only: %i[create] do
        resource :status, module: :recipe_searches, only: %i[show]
        resource :answer, module: :recipe_searches, only: %i[show]
      end
    end
  end
end
