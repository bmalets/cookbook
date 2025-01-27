# frozen_string_literal: true

FactoryBot.define do
  factory :doorkeeper_application, class: 'Doorkeeper::Application' do
    name { Faker::Lorem.word }
    scopes { Doorkeeper.configuration.default_scopes.to_a }
    redirect_uri { Faker::Internet.url(scheme: 'https') }
    uid { SecureRandom.hex(16) }
    secret { SecureRandom.hex(32) }

    trait :web_app do
      name { ENV.fetch('DOORKEEPER_WEB_APP_NAME') }
      scopes { %i[read] }
    end
  end
end
