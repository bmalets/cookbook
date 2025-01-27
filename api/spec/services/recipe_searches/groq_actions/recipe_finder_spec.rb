# frozen_string_literal: true

require 'rails_helper'

describe RecipeSearches::GroqActions::RecipeFinder do
  subject(:finder) { described_class.new(recipe_search:) }

  let(:recipe_search) { create(:recipe_search, :requested_search, ingredients: ingredients) }
  let(:ingredients) { [Faker::Food.ingredient, Faker::Food.ingredient] }
  let(:groq_client) { instance_double(GroqApi::Client) }
  let(:question_template) { Faker::Lorem.paragraph }
  let(:expected_response) { Faker::Food.description }

  before do
    allow(GroqApi::Client).to receive(:new).and_return(groq_client)
    allow(GroqQuestionTemplates).to receive(:find_receipt_by_ingredients).with(ingredients: ingredients).and_return(question_template)
    allow(groq_client).to receive(:ask_question).with(question: question_template).and_return(expected_response)
  end

  describe '#call' do
    subject(:perform_call) { finder.call }

    it 'returns the recipe from Groq' do
      expect(perform_call).to eq(expected_response)
    end

    it 'uses the correct question template' do
      perform_call
      expect(GroqQuestionTemplates).to have_received(:find_receipt_by_ingredients).with(ingredients: ingredients)
    end

    it 'asks Groq with the correct question' do
      perform_call
      expect(groq_client).to have_received(:ask_question).with(question: question_template)
    end
  end

  describe 'temperature setting' do
    it 'uses a temperature of 0.7 for creative responses' do
      expect(finder.send(:temperature)).to eq(0.7)
    end
  end
end
