# frozen_string_literal: true

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('WORKER_REDIS_URL') }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('WORKER_REDIS_URL') }

  config.on(:startup) do
    schedule_file = 'config/schedule.yml'

    if File.exist?(schedule_file)
      Sidekiq.schedule = YAML.load_file(schedule_file)
      SidekiqScheduler::Scheduler.instance.reload_schedule!
    end
  end
end

Sidekiq.default_job_options = {
  backtrace: ENV.fetch('SIDEKIQ_BACKTRACE', false),
  retry: ENV.fetch('SIDEKIQ_RETRY_COUNT', 5)
}

if ENV.fetch('SIDEKIQ_TESTING_INLINE', false) == 'true' || Rails.env.test?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
