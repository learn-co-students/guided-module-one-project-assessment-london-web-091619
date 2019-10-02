class Song < ActiveRecord::Base
    has_many :playlist_songs
    has_many :playlists, through: :playlist_songs

    def self.find_songs_by_genre(genre)
        self.all.select { |songs| songs.genre == genre }
    end

    def self.find_songs_by_mood(mood)
        self.all.select { |songs| songs.mood == mood }
    end
    
end


