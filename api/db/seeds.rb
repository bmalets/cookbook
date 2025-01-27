# frozen_string_literal: true

def run_rake_task(task:, exit_message:)
  Rake::Task[task].invoke
rescue SystemExit => _e
  Rails.logger.info(exit_message)
end

run_rake_task(task: 'seeds:doorkeeper:create_web_app', exit_message: 'Web app already exists.')
