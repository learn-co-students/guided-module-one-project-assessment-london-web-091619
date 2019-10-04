class CreatePlaylists < ActiveRecord::Migration[4.2]
  def change
    create_table :playlists do |t|
      t.integer :user_id
      t.string :title
    end
  end
end
