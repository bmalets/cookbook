# frozen_string_literal: true

module GroqApi
  module Operations
    class AskQuestion < BaseService
      ANSWER_ATTRIBUTE = 'content'

      # @param api_client [Groq::Client]
      # @param question [String]
      def initialize(api_client:, question:)
        @api_client = api_client
        @question = question
        super
      end

      def call
        response = @api_client.chat(@question)
        response.fetch(ANSWER_ATTRIBUTE)
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse Groq response: #{e.message}. Question: #{@question}")
        raise(e)
      rescue Faraday::Error => e
        Rails.logger.error("Groq API request failed: #{e.message}. Question: #{@question}")
        raise(e)
      end
    end
  end
end
