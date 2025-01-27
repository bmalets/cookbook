# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroqApi::Operations::AskQuestion do
  let(:api_client) { instance_double(Groq::Client) }
  let(:question) { Faker::Lorem.question }
  let(:service) { described_class.new(api_client: api_client, question: question) }

  describe '#call' do
    context 'when the API call is successful' do
      let(:api_response) { { 'content' => Faker::Lorem.sentence } }

      before do
        allow(api_client).to receive(:chat).with(question).and_return(api_response)
      end

      it 'returns the content from the API response' do
        expect(service.call).to eq(api_response['content'])
      end
    end

    context 'when JSON parsing fails' do
      before do
        allow(api_client).to receive(:chat).and_raise(JSON::ParserError.new('Invalid JSON'))
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error and re-raises it' do
        expect { service.call }.to raise_error(JSON::ParserError)
        expect(Rails.logger).to have_received(:error).with(
          "Failed to parse Groq response: Invalid JSON. Question: #{question}"
        )
      end
    end

    context 'when API request fails' do
      before do
        allow(api_client).to receive(:chat).and_raise(Faraday::Error.new('Connection failed'))
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error and re-raises it' do
        expect { service.call }.to raise_error(Faraday::Error)
        expect(Rails.logger).to have_received(:error).with(
          "Groq API request failed: Connection failed. Question: #{question}"
        )
      end
    end
  end
end
