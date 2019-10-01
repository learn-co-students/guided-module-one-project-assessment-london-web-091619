class CreateSongs < ActiveRecord::Migration[4.2]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :genre
      t.string :mood
      t.string :artist
    end
  end
end
