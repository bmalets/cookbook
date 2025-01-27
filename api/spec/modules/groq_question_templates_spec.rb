# frozen_string_literal: true

require 'rails_helper'

describe GroqQuestionTemplates do
  describe '.find_receipt_by_ingredients' do
    let(:ingredients) { Faker::Lorem.words(number: 2) }
    let(:template_path) { described_class::TEMPLATES[:find_receipt_by_ingredients] }

    it 'renders the template with given ingredients' do
      result = described_class.find_receipt_by_ingredients(ingredients: ingredients)
      expect(result).to include(*ingredients)
    end
  end

  describe '.confirm_text_is_real_recipe' do
    let(:recipe_text) { Faker::Food.vegetables }
    let(:template_path) { described_class::TEMPLATES[:confirm_text_is_real_recipe] }

    it 'renders the template with given recipe text' do
      result = described_class.confirm_text_is_real_recipe(probable_recipe_text: recipe_text)
      expect(result).to include(recipe_text)
    end
  end

  describe '.render_template' do
    let(:template_path) { described_class::TEMPLATES[:find_receipt_by_ingredients] }
    let(:args) { { ingredients: Faker::Lorem.words(number: 2) } }

    it 'renders ERB template with given arguments' do
      result = described_class.render_template(template_path, **args)
      expect(result).to be_a(String)
      expect(result).not_to be_empty
      expect(result).to include(*args[:ingredients])
    end

    context 'when template does not exist' do
      let(:template_path) { 'non/existent/path.erb' }

      it 'raises an error' do
        expect { described_class.render_template(template_path, **args) }
          .to raise_error(Errno::ENOENT)
      end
    end
  end
end
