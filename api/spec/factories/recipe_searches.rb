# frozen_string_literal: true

FactoryBot.define do
  factory :recipe_search do
    ingredients { [Faker::Food.vegetables, Faker::Food.vegetables] }
    status { RecipeSearch.statuses.values.sample }
    latest_activity_at { Faker::Time.backward(days: 1) }

    trait :requested_search do
      status { RecipeSearch.statuses[:pending_search] }
      latest_activity_at { Time.current }
    end

    trait :confirmed_answer do
      answer { Faker::Food.description }
      status { RecipeSearch.statuses[:confirmed] }
      latest_activity_at { Time.current }
    end
  end
end
