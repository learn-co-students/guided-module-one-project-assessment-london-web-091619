# This class is only talking to the user, not directly to the database
class MusicApp

    @@prompt = TTY::Prompt.new

    # WORKS!!!!! runs the app, welcomes user and prompts user to log in, if successful, shows main menu, if not, prompts re-try
    def run
        puts "Welcome to Moodsic! Discover songs you really like!"
        @current_user = login
        if @current_user 
            main_menu
        else
            puts "Ooops, we couldn't find you! Let's start your music journey again!"
            run
        end
    end

    # WORKS!!!!! checks if user is in database by looking for username and password
    def login
        username = @@prompt.ask("Continue exploring by entering your username: ")
        password = @@prompt.mask("Followed by your password: ")

        User.find_by(username: username, password: password)
    end

    # WORKS!!!!! Gives the user the option to go to their playlist or to look for new songs
    def main_menu
        selection = @@prompt.select("Are you looking for new songs, or do you want to checkout your playlist?", "Let me find new songs", "Let me head to my playlist")
        if selection == "Let me find new songs"
            find_new_songs
        else
            show_playlists
        end
    end
    
    # Gives the user the option to find new songs either by genre or by mood
    def find_new_songs
        selection = @@prompt.select("Do you fancy a specific genre, or are you in the mood for something?", "Let me browse through the genre", "I am moody, let me find the perfect songs")
            if selection == "Let me browse through the genre"
                choice1 = @@prompt.select("Which genre do you fancy:", "rock", "pop", "indie", "electro")
                @songs_array = Song.find_songs_by_genre(choice1).map { |songs| songs.title }
                puts @songs_array
                save_songs
            else
                choice2 = @@prompt.select("What is your mood:", "happy", "calm", "sad")
                @songs_array = Song.find_songs_by_mood(choice2).map { |songs| songs.title }
                puts @songs_array
                save_songs
            end     
    end

    # WORKS MOST LIKELY!!!!! Allows the user to view their playlist or prompts to create
    def show_playlists
        puts @current_user.all_playlist_titles
    end

    # Allows the user to choose songs and save them to their playlist
    def save_songs
        selection = @@prompt.select("Do you love those songs and want to add them to your playlist?", "Of course", "Nah, I want to continue browsing")
            if selection == "Of course"
                create_playlist
                @user_playlist << @songs_array
            else
                find_new_songs
            end    
    end

    # Allows the user to create a new playlist
    def create_playlist
        title = @@prompt.ask("Your playlist title should be: ")
        user_id = @current_user.get_user_id
        @user_playlist = Playlist.create_user_playlist(user_id: user_id, title: title)
    end


    # Allows the user to update playlist

    # Allows the user to delete playlist

    # Clear method to make it look less messy for the user

end