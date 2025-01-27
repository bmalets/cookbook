class CreateRecipeRequest < ActiveRecord::Migration[7.2]
  def up
    create_enum :recipe_search_status_type, %w[pending_search searching search_error pending_confirmation confirmation confirmed confirmation_failed confirmation_error]

    create_table :recipe_searches, id: :uuid do |t|
      t.enum :status, enum_type: :recipe_search_status_type, null: false, default: :pending_search
      t.string :ingredients, null: false, array: true, default: []
      t.text :answer, limit: 500_000
      t.timestamp :latest_activity_at
      t.timestamps
    end
  end

  def down
    drop_table :recipe_searches
    drop_enum :recipe_search_status_type
  end
end
