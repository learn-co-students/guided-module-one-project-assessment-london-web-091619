class CLI < CliMethods

  @@prompt = TTY::Prompt.new

  def logo_header
    puts "
     ▄███████▄    ▄████████    ▄████████    ▄█   ▄█▄    ▄████████         ▄████████ ███▄▄▄▄   ████████▄          ▄████████ ███    █▄  ▀█████████▄  ▄██   ▄
    ███    ███   ███    ███   ███    ███   ███ ▄███▀   ███    ███        ███    ███ ███▀▀▀██▄ ███   ▀███        ███    ███ ███    ███   ███    ███ ███   ██▄
    ███    ███   ███    ███   ███    ███   ███▐██▀     ███    █▀         ███    ███ ███   ███ ███    ███        ███    ███ ███    ███   ███    ███ ███▄▄▄███
    ███    ███   ███    ███  ▄███▄▄▄▄██▀  ▄█████▀      ███               ███    ███ ███   ███ ███    ███       ▄███▄▄▄▄██▀ ███    ███  ▄███▄▄▄██▀  ▀▀▀▀▀▀███
  ▀█████████▀  ▀███████████ ▀▀███▀▀▀▀▀   ▀▀█████▄    ▀███████████      ▀███████████ ███   ███ ███    ███      ▀▀███▀▀▀▀▀   ███    ███ ▀▀███▀▀▀██▄  ▄██   ███
    ███          ███    ███ ▀███████████   ███▐██▄            ███        ███    ███ ███   ███ ███    ███      ▀███████████ ███    ███   ███    ██▄ ███   ███
    ███          ███    ███   ███    ███   ███ ▀███▄    ▄█    ███        ███    ███ ███   ███ ███   ▄███        ███    ███ ███    ███   ███    ███ ███   ███
   ▄████▀        ███    █▀    ███    ███   ███   ▀█▀  ▄████████▀         ███    █▀   ▀█   █▀  ████████▀         ███    ███ ████████▀  ▄█████████▀   ▀█████▀
                              ███    ███   ▀                                                                    ███    ███
\n"
  end

  def run
    clear_console
    puts "Welcome to: "
    logo_header
    @current_user = login
  end

  def login
    @current_user = User.find_user_by_name_and_password
    login_validation
  end

  def login_validation
    clear_console
    logo_header
    if @current_user
      main_menu
    else
      puts "Sorry, that username/password combo wasn't recognised. Please try again."
      login
    end
  end

  def main_menu
    @menu_selection = @@prompt.select("What would you like to do today?", "See my reviews.", "Review a park.", "Delete a review.", "Update a review.","See average ratings of parks.", "Exit.")
    menu_choice
  end

  def menu_choice
    clear_console
    logo_header
    case @menu_selection
    when "See my reviews."
      print_user_reviews
    when "Review a park."
      review_parks
    when "Delete a review."
      park_delete_review
    when "Update a review."
      park_update_review
    when "See average ratings of parks."
      average_rating
    else
      if_choice_is_exit
    end
    main_menu
  end

  def if_choice_is_exit
    if @park_selection == "Exit." || @review_selection == "Exit." || @menu_selection == "Exit."
      clear_console
      puts "Goodbye, don't forget to bring sunscreen!"
      exit!
    end
  end


end


#work through refactoring ,average top 3 reviews, average rating, top 3, most reviews.
#make console puts out links for the parks on google maps or wikipedia or something along those lines.
