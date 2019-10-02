class User < ActiveRecord::Base
    has_many :playlists

    # gives us all the playlists of this user
    def all_playlist_titles 
        playlist_array = self.playlists.map { |playlist| playlist.title }
        playlist_array
    end

end


