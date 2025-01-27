# frozen_string_literal: true

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec/fixtures/vcr')
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data('__GROQ_API_KEY__') { ENV.fetch('GROQ_API_KEY') }
end
