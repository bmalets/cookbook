# frozen_string_literal: true

FactoryBot.define do
  factory :doorkeeper_application_access_token, class: 'Doorkeeper::AccessToken' do
    application_id { create(:doorkeeper_application).id }
    token { Faker::Internet.device_token }
    refresh_token { Faker::Internet.device_token }
    expires_in { Faker::Number.between(from: 3600, to: 7200) }
    scopes { Doorkeeper.configuration.default_scopes.to_a }

    trait :web_app do
      application_id { create(:doorkeeper_application, :web_app).id }
      scopes { %i[read] }
    end
  end
end
