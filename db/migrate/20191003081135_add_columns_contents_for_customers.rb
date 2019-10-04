class AddColumnsContentsForCustomers < ActiveRecord::Migration[5.2]
  def change

    add_column :reviews, :content_for_customers, :string
  end
end
