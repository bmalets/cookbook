# frozen_string_literal: true

class RecipeSearch < ApplicationRecord
  include AASM

  MAX_ANSWER_LENGTH = 500_000

  enum :status, { pending_search: 'pending_search',
                  searching: 'searching',
                  search_error: 'search_error',
                  pending_confirmation: 'pending_confirmation',
                  confirmation: 'confirmation',
                  confirmed: 'confirmed',
                  confirmation_failed: 'confirmation_failed',
                  confirmation_error: 'confirmation_error' }, validate: true, prefix: true

  scope :inactive_since, ->(datetime) { where(arel_table[:latest_activity_at].lt(datetime)) }
  scope :could_be_answered, -> { status_pending_search.or(status_search_error) }
  scope :could_be_confirmed, -> { status_pending_confirmation.or(status_confirmation_error) }

  validates :ingredients, presence: true
  validates :answer, length: { maximum: MAX_ANSWER_LENGTH }, presence: true, if: :with_answer?

  aasm(:status, column: :status, enum: true) do # rubocop:disable Metrics/BlockLength
    state :pending_search, initial: true
    state :searching
    state :search_error
    state :pending_confirmation
    state :confirmation
    state :confirmed
    state :confirmation_failed
    state :confirmation_error

    event :start_searching do
      transitions from: %i[search_error pending_search], to: :searching
    end

    event :mark_search_as_api_error do
      transitions from: :searching, to: :search_error
    end

    event :mark_search_as_succeeded do
      transitions from: %i[searching], to: :pending_confirmation
    end

    event :start_confirmation do
      transitions from: %i[pending_confirmation confirmation_error], to: :confirmation
    end

    event :mark_confirmation_as_failed do
      transitions from: :confirmation, to: :confirmation_failed
    end

    event :mark_confirmation_as_succeeded do
      transitions from: :confirmation, to: :confirmed
    end

    event :mark_as_confirmation_api_error do
      transitions from: :confirmation, to: :confirmation_error
    end
  end

  def failed_status?
    status_search_error? || status_confirmation_error?
  end

  private

  def with_answer?
    status_pending_confirmation? || status_confirmation? || status_confirmed? ||
      status_confirmation_failed? || status_confirmation_error?
  end
end
