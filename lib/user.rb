class User < ActiveRecord::Base
    has_many :playlists

    # gives us all the playlists of this user
    def all_playlist_titles 
        playlist_array = self.playlists.map { |playlist| playlist.title }
        playlist_array
    end

    # def sort_playlist_asc
    #    all_titles = all_playlist_titles
    #    all_titles.sort
    # end

    # def sort_playlist_desc
    #     all_titles = all_playlist_titles
    #     all_titles.sort { |song_first, song_last| song_last <=> song_first }
    # end

    # def new_user
    #     username = @@prompt.ask("In order to explore the fabulous world of MoodSic, just sign-up with your preferred username: ")
    #     password = @@prompt.mask("Followed by a password: ")
    #     User.create(username: username, password: password)
    #     @current_user = User.find_by(username: username, password: password)
    # end

end


