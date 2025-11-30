class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: 'pending'
      t.integer :total_amount, null: false
      t.integer :used_points, default: 0, null: false
      t.integer :earned_points, default: 0, null: false

      t.timestamps
    end
  end
end
