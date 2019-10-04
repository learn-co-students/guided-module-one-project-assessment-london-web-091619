class MusicApp

    @@prompt = TTY::Prompt.new

    # Runs the app, welcomes user and prompts user to log in, if successful, shows main menu, if not, prompts re-try
    def run
        clear_terminal
        puts "WELCOME TO MOODSIC! DISCOVER A BUNCH OF SONGS YOU REALLY LIKE!".light_blue.bold
        selection = @@prompt.select("If you're a MoodSic oldie, just log in with your details. If you're new to this, just create an account - it's that easy!", "Log in", "Sign up" )
        if selection == "Log in"
            login
        else
            sign_up
        end
    end

    # Matches login data with database
    def login
        username = @@prompt.ask("In order to explore the fabulous world of MoodSic, just log in with your username: ")
        password = @@prompt.mask("Followed by your password: ")
        @current_user = User.find_by(username: username, password: password)
        if @current_user
            sleep(2)
            main_menu
        else
            puts "Ooops, we couldn't find you! Let's start your music journey again!"
            sleep(1)
            login
        end
    end

    # Allows a new user to sign-up
    def sign_up
        username = @@prompt.ask("In order to explore the fabulous world of MoodSic, sign up with a username: ")
        password = @@prompt.mask("Followed by a password: ")
        @current_user = User.create(username: username, password: password)
        puts "Great, welcome to the MoodSic family!"
        sleep(2)
        main_menu
    end

    # Gives the user the option to find songs or to go to the playlist menu
    def main_menu
        clear_terminal
        selection = @@prompt.select("Hello again! Do you want to check out some new favourite tunes, or jump to your playlists?", "Bring the tunes in", "Playlists, obviously", "Logout")
        if selection == "Bring the tunes in"
            songs_prompt
        elsif selection == "Playlists, obviously"
            playlists_prompt
        else
            exit 
        end
    end
    
    # Gives user the option to search for songs via genre or via mood
    def songs_prompt
        clear_terminal
        selection = @@prompt.select("Do you fancy a specific genre, or are you in the mood for something?", "Let me browse through the genre", "I am moody, let me find the perfect songs", "-back-")
        if selection == "Let me browse through the genre"
            songs_by_genre
        elsif selection == "I am moody, let me find the perfect songs"
            songs_by_mood 
        else
            main_menu
        end     
    end
    
    # Gives user the songs for the selected genre, or lets user go back to song menu
    def songs_by_genre
        clear_terminal
        selection = @@prompt.select("Which genre do you fancy:", "rock", "pop", "indie", "electro", "-back-")
        if selection == "rock" || selection == "pop" || selection =="indie" || selection == "electro"
            @songs_array = Song.song_title_genre(selection)
            puts "We think that you might like these songs:"
            puts @songs_array
            add_songs?
        else
            songs_prompt
        end
    end

    # Gives user the songs for the selected mood, or lets user go back to song menu
    def songs_by_mood 
        clear_terminal
        selection = @@prompt.select("What is your mood:", "happy", "calm", "sad", "-back-")
        if selection == "happy" || selection == "calm" || selection == "sad"
            @songs_array = Song.song_title_mood(selection)
            puts "We think that you might like these songs:"
            puts @songs_array
            add_songs?
        else
            songs_prompt
        end
    end

    # Allows the user to decide whether to create a playlist with the listed songs or not
    def add_songs?
        selection = @@prompt.select("Do you love those songs (as much as we do) and want to have them in a playlist?", "Yes, definitely loving them", "Nah, I want to continue browsing", "-back-")
            if selection == "Yes, definitely loving them"
                create_playlist
            elsif selection == "Nah, I want to continue browsing"
                songs_prompt
            else
                main_menu
            end    
    end

    # Allows the user to create a playlist with a title
    def create_playlist
        @playlist_title = @@prompt.ask("Your playlist title should be: ")
        user_id = @current_user.id
        @user_playlist = Playlist.create(user_id: user_id, title: @playlist_title)
        save_playlist
    end
    
    # Allows the user to save the named playlist with the found songs
    def save_playlist
        songs_instances = @songs_array.map { |title| Song.find_by(title: title) }
        songs_instances.each { |song| PlaylistSong.create(playlist_id: @user_playlist.id, song_id: song.id) }
        update_user
        puts "Wooohooo! You successfully created your playlist #{@playlist_title}!"
        puts "Let's bring you back to the main menu!"
        sleep(3)
        main_menu    
    end

    # Gives user the option to view playlists, rename or delete a playlist
    def playlists_prompt
        selection = @@prompt.select("Your playlists, your choice!", "Let me view all my playlists", "I am older and wiser now - let me rename my playlist", "Even older and wiser - let me get rid of a playlist", "-back-")
        if selection == "Let me view all my playlists"
            view_playlists
        elsif selection == "I am older and wiser now - let me rename my playlist"
            update_playlist_title
        elsif selection == "Even older and wiser - let me get rid of a playlist"
            delete_playlist
        else
            main_menu
        end  
    end

    # Shows playlist or tells user that there are no playlists yet, with leading user to song menu
    def view_playlists
        playlist_existing
        if @current_user.all_playlist_titles.empty?
            playlist_not_existing
        else
            puts "You have #{@current_user.number_of_playlists} playlist(s):"
            puts "There are on average #{@current_user.average_songs_per_playlist} songs in your playlist."
            puts @playlist_list
            puts "Looking great! What do you want to do now?"
            playlists_prompt
        end
    end
 
    # Allows the user to change the playlist title
    def update_playlist_title
        playlist_existing
        if @current_user.all_playlist_titles.any?
            chosen_playlist = @@prompt.select("Which one of your playlists do you want to rename?", @current_user.all_playlist_titles)
            new_playlist_title = @@prompt.ask("What's the new title supposed to be? ")
            playlist_to_change = Playlist.find_by(title: chosen_playlist) 
            playlist_to_change.update(title: new_playlist_title)
            update_user        
            puts "#{new_playlist_title} is looking sick now!"
            playlists_prompt
        else
            playlist_not_existing
        end 
    end

    # Allows the user to delete playlist
    def delete_playlist
        playlist_existing
        if @current_user.all_playlist_titles.any?
            chosen_playlist = @@prompt.select("Which one of your playlists do you want to delete?", @current_user.all_playlist_titles)
            playlist_to_delete = Playlist.find_by(title: chosen_playlist)
            playlist_to_delete.destroy
            update_user
            puts "Bye bye!"
            playlists_prompt    
        else
            playlist_not_existing
        end
    end

    # Puts out error message if no playlist in database and leads to song menu
    def playlist_not_existing
        puts "You don't have any playlists (yet). Find new songs to create a playlist with them!"
        sleep(2)
        songs_prompt
    end

    # Saves user's playlist to playlist variable
    def playlist_existing
        @playlist_list = @current_user.all_playlist_titles
    end

    # Updates user data after changes
    def update_user
        @current_user = User.find(@current_user.id)
    end

    # Clears the terminal to make it look nicer for the user
    def clear_terminal
        system("clear")
    end

end

