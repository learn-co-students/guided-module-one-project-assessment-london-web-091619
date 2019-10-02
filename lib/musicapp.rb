class MusicApp

    @@prompt = TTY::Prompt.new

    # Runs the app, welcomes user and prompts user to log in, if successful, shows main menu, if not, prompts re-try
    def run
        clear_terminal
        puts "Welcome to Moodsic! Discover songs you really like!"
        @current_user = login
        if @current_user 
            main_menu
        else
            puts "Ooops, we couldn't find you! Let's start your music journey again!"
            run
        end
    end

    # Checks if user is in database by looking for username and password
    def login
        username = @@prompt.ask("Continue exploring by entering your username: ")
        password = @@prompt.mask("Followed by your password: ")
        User.find_by(username: username, password: password)
    end

    # Gives the user the option to look for new songs, see playlist, update or delete playlist
    def main_menu
        selection = @@prompt.select("Howdy! What do you want to do now?", "...I want to find new songs", "...I want to see my playlists", "...I want to update my playlist titles", "...I want to delete my playlist")
        if selection == "...I want to find new songs"
            find_new_songs
        elsif selection == "...I want to see my playlists"
            show_playlists
        elsif selection == "...I want to update my playlist titles"
            update_playlist_title
        else
            delete_playlist
        end
    end
    
    # Gives the user the option to find new songs either by genre or by mood
    def find_new_songs
        selection = @@prompt.select("Do you fancy a specific genre, or are you in the mood for something?", "Let me browse through the genre", "I am moody, let me find the perfect songs")
            if selection == "Let me browse through the genre"
                choice1 = @@prompt.select("Which genre do you fancy:", "rock", "pop", "indie", "electro")
                @songs_array = Song.find_songs_by_genre(choice1).map { |songs| songs.title }
                puts @songs_array
                add_songs?
            else
                choice2 = @@prompt.select("What is your mood:", "happy", "calm", "sad")
                @songs_array = Song.find_songs_by_mood(choice2).map { |songs| songs.title }
                puts @songs_array
                add_songs?
            end     
    end

    # Allows the user to decide whether to add songs to playlist or not
    def add_songs?
        selection = @@prompt.select("Do you love those songs and want to add them to your playlist?", "Yes, definitely loving them", "Nah, I want to continue browsing")
            if selection == "Yes, definitely loving them"
                create_playlist
            else
                find_new_songs
            end    
    end

    # Allows the user to create a new playlist
    def create_playlist
        clear_terminal
        @playlist_title = @@prompt.ask("Your playlist title should be: ")
        user_id = @current_user.id
        @user_playlist = Playlist.create(user_id: user_id, title: @playlist_title)
        save_songs
    end
    
    # Allows the user to save the songs to the newly created playlist
    def save_songs
        clear_terminal
        songs_instances = @songs_array.map { |title| Song.find_by(title: title) }
        songs_instances.each { |song| PlaylistSong.create(playlist_id: @user_playlist.id, song_id: song.id) }
        puts "Wooohooo! You successfully created your playlist #{@playlist_title}!"
        main_menu    
    end

    # Allows the user to view their playlists (if they are having any)
    def show_playlists
        clear_terminal
        @playlist_list = @current_user.all_playlist_titles
        if @current_user.all_playlist_titles.empty?
            puts "You don't have any playlists (yet). Find new songs to create a playlist with them!"
            find_new_songs
        else
            puts @playlist_list
            selection = @@prompt.select("Do you want to rename one of your playlists?", "Absolutely", "Nope")
                if selection == "Absolutely"
                update_playlist_title
            else
                puts "Okidoki, let's just go back to the main menu then"
                main_menu
            end
        end
    end

    # Allows the user to change the playlist title
    def update_playlist_title
        chosen_playlist = @@prompt.select("Which one of your playlists do you want to rename?", @current_user.all_playlist_titles)
        new_playlist_title = @@prompt.ask("What's the new title supposed to be?" )
        playlist_to_change = Playlist.find_by(title: chosen_playlist) 
        playlist_to_change.update(title: new_playlist_title)
        @current_user = User.find(@current_user.id)
        puts "#{new_playlist_title} is looking sick now!"
        main_menu
    end

    # Allows the user to delete playlist
    def delete_playlist
        clear_terminal
        chosen_playlist = @@prompt.select("Which one of your playlists do you want to delete?", @current_user.all_playlist_titles)
        playlist_to_delete = Playlist.find_by(title: chosen_playlist)
        playlist_to_delete.destroy
        @current_user = User.find(@current_user.id)
        puts "Bye bye!"
        main_menu     
    end

    def clear_terminal
        system("clear")
    end


    # Back method for every menu to have the option to go back to previous menu

# Delete created playlists

    # Strech: Allows to add only one song and delete only one song
    # Strech: Sort playlist ASC or DESC etc.

end

