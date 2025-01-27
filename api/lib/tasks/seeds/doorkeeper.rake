# frozen_string_literal: true

namespace :seeds do
  namespace :doorkeeper do
    desc 'Create Doorkeeper web application'
    task create_web_app: :environment do
      app_name = ENV.fetch('DOORKEEPER_WEB_APP_NAME')
      app_uid = ENV.fetch('DOORKEEPER_WEB_APP_ID')
      app_secret = ENV.fetch('DOORKEEPER_WEB_APP_SECRET')

      exit if Doorkeeper::Application.exists?(uid: app_uid)

      Doorkeeper::Application.create!(name: app_name,
                                      uid: app_uid,
                                      secret: app_secret,
                                      redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
                                      scopes: %w[read])
    end
  end
end
