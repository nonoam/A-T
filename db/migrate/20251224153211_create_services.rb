class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :duration
      t.integer :modality, default: 0, null: false
      t.integer :price_cents, default: 0, null: false
      t.timestamps
    end
  end
end
