# frozen_string_literal: true

module GroqApi
  class Client
    def initialize(temperature:)
      @api_client = ::Groq::Client.new(temperature:)
    end

    def ask_question(question:)
      Operations::AskQuestion.call(api_client: @api_client, question:)
    end
  end
end
