class User < ActiveRecord::Base
    has_many :playlists

    # gives us all the playlists of this user
    def all_playlist_titles 
        playlist_array = self.playlists.map { |playlist| playlist.title }
        playlist_array
    end

    def number_of_playlists
        self.playlists.count
    end

    def average_songs_per_playlist
        song_numbers = self.playlists.map { |playlist| playlist.songs.count }
        average = song_numbers.sum.to_f / number_of_playlists.to_f
        average.round(2)
    end

end


