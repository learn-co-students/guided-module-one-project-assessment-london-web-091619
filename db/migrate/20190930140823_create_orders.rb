class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :gelato_id
      t.string :order_time
      t.string :status
      t.integer :total
      t.integer :servings
    end
  end
end
