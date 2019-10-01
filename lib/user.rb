class User < ActiveRecord::Base
    has_many :playlists

    # gives us all the playlists of this user
    def all_playlist_titles 
        playlist_array = self.playlists.map { |playlist| playlist.title }
        puts playlist_array
    end

    def get_user_id
        self.id
    end


end
