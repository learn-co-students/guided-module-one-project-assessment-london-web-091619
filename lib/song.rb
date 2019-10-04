class Song < ActiveRecord::Base
    has_many :playlist_songs
    has_many :playlists, through: :playlist_songs

    def self.find_songs_by_genre(genre)
        self.all.select { |songs| songs.genre == genre }
    end

    def self.find_songs_by_mood(mood)
        self.all.select { |songs| songs.mood == mood }
    end

    def self.song_title_genre(selection)
        self.all.find_songs_by_genre(selection).map { |songs| songs.title }
    end

    def self.song_title_mood(selection)
        self.all.find_songs_by_mood(selection).map { |songs| songs.title }
    end 
    
end


