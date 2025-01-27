# frozen_string_literal: true

Groq.configure do |config|
  config.api_key = ENV.fetch('GROQ_API_KEY')
  config.model_id = ENV.fetch('GROQ_MODEL_ID')
end
