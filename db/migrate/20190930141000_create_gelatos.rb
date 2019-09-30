class CreateGelatos < ActiveRecord::Migration[5.2]
  def change
    create_table :gelatos do |t|
      t.string :flavour
      t.integer :stock
      t.string :description
    end
  end
end
