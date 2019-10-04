class CreateParks < ActiveRecord::Migration[5.2]
  def change
    create_table :parks do |t|
      t.string :name
      t.string :location
      t.integer :year_opened
      t.float :size_in_acres
      t.float :price
    end
  end
end
