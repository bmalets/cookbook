# frozen_string_literal: true

require 'rails_helper'

describe RecipeSearches::CreateService do
  describe '#call' do
    subject(:service_call) { described_class.new(attributes: attributes).call }

    let(:attributes) { { ingredients: [Faker::Food.ingredient, Faker::Food.ingredient] } }

    context 'when attributes are valid' do
      it 'creates a new recipe search' do
        expect { service_call }.to change(RecipeSearch, :count).by(1)
      end

      it 'sets the latest_activity_at timestamp' do
        freeze_time do
          recipe_search = service_call
          expect(recipe_search.latest_activity_at).to eq(Time.current)
        end
      end

      it 'enqueues a SearchJob' do
        expect { service_call }
          .to have_enqueued_job(RecipeSearches::SearchJob)
          .with(kind_of(RecipeSearch))
      end

      it 'returns the created recipe search' do
        expect(service_call).to be_a(RecipeSearch)
        expect(service_call).to be_persisted
      end
    end

    # ... rest of the tests remain the same ...
  end
end
