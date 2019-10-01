class Playlist < ActiveRecord::Base
    belongs_to :user
    has_many :songs, through: :playlistsong

    def self.create_user_playlist(user_id, title)
        Playlist.new(user_id: user_id, title: title)
        @@all << self
    end

end
