# frozen_string_literal: true

require 'rails_helper'

describe RecipeSearch do
  subject(:recipe_search) { build(:recipe_search) }

  describe 'enums' do
    it { # rubocop:disable RSpec/ExampleLength
      expect(recipe_search)
        .to define_enum_for(:status).with_values(pending_search: 'pending_search',
                                                 searching: 'searching',
                                                 search_error: 'search_error',
                                                 pending_confirmation: 'pending_confirmation',
                                                 confirmation: 'confirmation',
                                                 confirmed: 'confirmed',
                                                 confirmation_failed: 'confirmation_failed',
                                                 confirmation_error: 'confirmation_error')
                                    .backed_by_column_of_type(:enum)
                                    .with_prefix(:status)
    }
  end

  describe 'scopes' do
    describe '.inactive_since' do
      subject(:scope) { described_class.inactive_since(1.hour.ago) }

      before { create(:recipe_search, :confirmed_answer, latest_activity_at: 30.minutes.ago) }

      let!(:inactive_search) { create(:recipe_search, :confirmed_answer, latest_activity_at: 2.hours.ago) }

      it 'returns searches inactive since given datetime' do
        expect(scope).to eq([inactive_search])
      end
    end

    describe '.could_be_answered' do
      subject(:scope) { described_class.could_be_answered }

      let!(:pending_search) { create(:recipe_search, status: :pending_search) }
      let!(:search_error) { create(:recipe_search, status: :search_error) }

      before { create(:recipe_search, status: :confirmed, answer: Faker::Lorem.sentence) }

      it 'returns searches that could be answered' do
        expect(scope).to contain_exactly(pending_search, search_error)
      end
    end

    describe '.could_be_confirmed' do
      subject(:scope) { described_class.could_be_confirmed }

      let!(:pending_confirmation) { create(:recipe_search, status: :pending_confirmation, answer: Faker::Lorem.word) }
      let!(:confirmation_error) { create(:recipe_search, status: :confirmation_error, answer: Faker::Lorem.word) }

      before { create(:recipe_search, status: :confirmed, answer: Faker::Lorem.sentence) }

      it 'returns searches that could be confirmed' do
        expect(scope).to contain_exactly(pending_confirmation, confirmation_error)
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ingredients) }

    context 'when answer is present' do
      subject(:recipe_search) { build(:recipe_search, :confirmed_answer) }

      it { is_expected.to validate_presence_of(:answer).with_message("can't be blank") }
      it { is_expected.to validate_length_of(:answer).is_at_most(500_000) }
    end

    context 'when answer is not present' do
      subject(:recipe_search) { build(:recipe_search, :requested_search) }

      it { is_expected.not_to validate_presence_of(:answer) }
    end
  end

  describe '#failed_status?' do
    subject(:recipe_search) { build(:recipe_search) }

    context 'when status is search_error' do
      before { recipe_search.status = :search_error }

      it { expect(recipe_search.failed_status?).to be true }
    end

    context 'when status is confirmation_error' do
      before { recipe_search.status = :confirmation_error }

      it { expect(recipe_search.failed_status?).to be true }
    end

    context 'when status is not failed' do
      before { recipe_search.status = :pending_search }

      it { expect(recipe_search.failed_status?).to be false }
    end
  end

  describe 'status AASM' do
    subject(:recipe_search) { build(:recipe_search, status: :pending_search) }

    it { is_expected.to transition_from(:pending_search).to(:searching).on_event(:start_searching).on(:status) }
    it { is_expected.to transition_from(:search_error).to(:searching).on_event(:start_searching).on(:status) }
    it { is_expected.to transition_from(:searching).to(:search_error).on_event(:mark_search_as_api_error).on(:status) }
    it { is_expected.to transition_from(:searching).to(:pending_confirmation).on_event(:mark_search_as_succeeded).on(:status) }
    it { is_expected.to transition_from(:confirmation_error).to(:confirmation).on_event(:start_confirmation).on(:status) }
    it { is_expected.to transition_from(:pending_confirmation).to(:confirmation).on_event(:start_confirmation).on(:status) }
    it { is_expected.to transition_from(:confirmation).to(:confirmation_failed).on_event(:mark_confirmation_as_failed).on(:status) }
    it { is_expected.to transition_from(:confirmation).to(:confirmed).on_event(:mark_confirmation_as_succeeded).on(:status) }
    it { is_expected.to transition_from(:confirmation).to(:confirmation_error).on_event(:mark_as_confirmation_api_error).on(:status) }
  end
end
