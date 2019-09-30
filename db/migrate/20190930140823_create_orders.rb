class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :order_time
      t.string :status
      t.integer :total
      t.integer :servings
    end
  end
end
