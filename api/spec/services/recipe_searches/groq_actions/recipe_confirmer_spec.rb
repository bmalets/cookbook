# frozen_string_literal: true

require 'rails_helper'

describe RecipeSearches::GroqActions::RecipeConfirmer do
  subject(:confirmer) { described_class.new(recipe_search:) }

  let(:recipe_search) { create(:recipe_search, answer: recipe_text) }
  let(:recipe_text) { Faker::Food.description }
  let(:groq_client) { instance_double(GroqApi::Client) }
  let(:question_template) { Faker::Lorem.question }

  before do
    allow(GroqApi::Client).to receive(:new).and_return(groq_client)
    allow(GroqQuestionTemplates).to receive(:confirm_text_is_real_recipe)
      .with(probable_recipe_text: recipe_text).and_return(question_template)
  end

  describe '#call' do
    subject(:perform_call) { confirmer.call }

    context 'when Groq confirms it is a recipe' do
      before { allow(groq_client).to receive(:ask_question).with(question: question_template).and_return('YES') }

      it { is_expected.to be true }
    end

    context 'when Groq indicates it is not a recipe' do
      before { allow(groq_client).to receive(:ask_question).with(question: question_template).and_return('NO') }

      it { is_expected.to be false }
    end

    context 'when Groq gives an unexpected answer' do
      before { allow(groq_client).to receive(:ask_question).with(question: question_template).and_return(Faker::Lorem.word) }

      it { is_expected.to be false }
    end
  end

  describe 'temperature setting' do
    it 'uses a temperature of 0 for maximum accuracy' do
      expect(confirmer.send(:temperature)).to eq(0)
    end
  end
end
