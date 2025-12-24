class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :status, default: 0, null: false # 0: pending
      t.timestamps
    end
  end
end
