# frozen_string_literal: true

require 'rails_helper'

describe System::RemoveInactiveRecipeSearchesJob do
  describe '#perform' do
    subject(:perform_job) { described_class.perform_now }

    let(:cut_off_days) { 30 }

    before do
      allow(ENV).to receive(:fetch).with('REMOVE_INACTIVE_RECIPE_SEARCHES_AFTER_IN_DAYS').and_return(cut_off_days)
    end

    context 'when there are active searches' do
      before { create(:recipe_search, :confirmed_answer, latest_activity_at: (cut_off_days - 1).days.ago) }

      it 'does not remove active recipe search' do
        expect { perform_job }.not_to change(RecipeSearch, :count)
      end
    end

    context 'when there are inactive searches' do
      before { create(:recipe_search, :confirmed_answer, latest_activity_at: (cut_off_days + 1).days.ago) }

      it 'removes inactive recipe search' do
        expect { perform_job }.to change(RecipeSearch, :count).by(-1)
      end
    end

    context 'when there are no inactive searches' do
      before { create(:recipe_search, :confirmed_answer, latest_activity_at: (cut_off_days - 1).days.ago) }

      it 'does not remove any searches' do
        expect { perform_job }.not_to change(RecipeSearch, :count)
      end
    end
  end
end
