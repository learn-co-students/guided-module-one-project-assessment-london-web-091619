class AddColumnsRatingForCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :rating_for_customers, :float
  end
end
