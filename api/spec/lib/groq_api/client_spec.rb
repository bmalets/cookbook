# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroqApi::Client do
  subject(:client) { described_class.new(temperature: temperature) }

  let(:temperature) { Faker::Number.decimal(l_digits: 1, r_digits: 1) }
  let(:question) { Faker::Lorem.question }
  let(:groq_client) { instance_double(Groq::Client) }

  before do
    allow(Groq::Client).to receive(:new).with(temperature: temperature).and_return(groq_client)
  end

  describe '#ask_question' do
    let(:operation_result) { Faker::Lorem.sentence }

    before do
      allow(GroqApi::Operations::AskQuestion).to receive(:call)
        .with(api_client: groq_client, question: question)
        .and_return(operation_result)
    end

    it 'delegates to Operations::AskQuestion' do
      client.ask_question(question: question)
      expect(GroqApi::Operations::AskQuestion).to have_received(:call)
        .with(api_client: groq_client, question: question)
    end

    it 'returns the operation result' do
      expect(client.ask_question(question: question)).to eq(operation_result)
    end
  end
end
