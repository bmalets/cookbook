# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Services', 'app/services'
  add_group 'Modules', 'app/modules'
  add_group 'Libs', 'app/lib'
end

require 'spec_helper'
require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'
require 'aasm/rspec'
require 'super_diff/rspec-rails'

Rails.root.glob('spec/support/**/*.rb').each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = ["#{Rails.root.join('spec/fixtures')}"]

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include ApiHelper, type: :request
end
