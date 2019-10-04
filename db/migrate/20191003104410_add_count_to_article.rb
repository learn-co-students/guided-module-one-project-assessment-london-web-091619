class AddCountToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :read_count, :integer
  end
end
