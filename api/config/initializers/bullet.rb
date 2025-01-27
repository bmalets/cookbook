# frozen_string_literal: true

if defined?(Bullet)
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable = true
      Bullet.alert = false
      Bullet.bullet_logger = true
      Bullet.raise = ENV.fetch('BULLET_RAISE_ERRORS', 'false').eql?('true')
      Bullet.console = false
      Bullet.rails_logger = true
      Bullet.add_footer = false
    end
  end
end
