class Cli
    @@prompt = TTY::Prompt.new
    #####################################
    #Welcome
    def welcome(sleep_value = 0.1)
        print_logo(sleep_value)
        puts "Welcome to tl;dr news service!"
        selection = @@prompt.select("Log in or Sign up!", "Log In", "Sign Up", "Exit")    
        case selection
            when "Log In"
                login
            when "Sign Up"
                sign_up_prompt
            when "Exit"
                abort("Goodbye!")
        end
    end

    ###
    #Sign up 
    def sign_up_prompt
        print_logo
        user_name = @@prompt.ask("Enter a unique username: ")
        password = @@prompt.mask("Enter a secure password: ")
        validate_sign_up(user_name, password)
    end

    #Sign up
    def validate_sign_up(user_name, password)
        if !check_for_duplicate_usernames(user_name) && validate_input(user_name) && validate_input(password)
            create_new_user(user_name, password)
            set_current_user(user_name, password)
            main_menu
        else 
            @@prompt.keypress("Usernames and passwords cannot be empty!")
            welcome(0) 
        end
    end

    #Create new user
    def create_new_user(user_name, password)
        User.create(user_name: user_name, password: password)
    end


    #Check duplicate usernames
    def check_for_duplicate_usernames(user_name)
        User.find_by(user_name: user_name) 
    end
    
    ###
    #Login
    def login
        username = @@prompt.ask("Please enter your username: ")
        password = @@prompt.mask("Please enter your password: ")
        validate(username, password)
    end

    #validate
    def validate(username, password)
        set_current_user(username, password)
        if @current_user
            main_menu
        else 
            @@prompt.keypress("We could not find your user! Please try again or sign up!")
            welcome(0)
        end
    end

    #set current username
    def set_current_user(username, password)
        @current_user = User.find_by(user_name: username, password: password)
    end
    
    #####################################
    #Main Menu 
    def main_menu
        print_logo
       selection= @@prompt.select("Choose an option please!", "Choose an article","View comments","Write an article","View your articles", "Get fresh articles","Statistics", "Log out", "Exit")
        case selection 
        when "Choose an article"
            article = select_article
            increment_article_count(article)
            comment_menu(article)
        when "View comments"
            view_comments
            main_menu
        when "Write an article"
            input_new_article
        when "View your articles"
            select_users_articles
        when "Get fresh articles"
            get_fresh_articles
            main_menu
        when "Statistics"
            get_statistics
        when "Log out"
            @current_user = nil
            welcome(0)
        when "Exit"
            abort("Goodbye!")
        end
    end

    ###
    #Choose an article
    def select_article
        print_logo
        if Article.all != []
            selection = @@prompt.select("Select an article please!", Article.map_names << "Main menu")
        if selection == "Main menu"
            main_menu
        end
            article = Article.find_article_by_name(selection)
            print_article(article)
        else
            @@prompt.keypress("There are no articles! Choose the 'Get fresh articles' option on the main menu!")
            main_menu
        end
    end

    def increment_article_count(article)
        article.increment!(:read_count)
        refresh_user
    end

    ##
    #Comment Menu
    def comment_menu(article)
        selection=@@prompt.select("would you like to make a comment?","Main menu","Make Comment") 
        if selection=="Main menu"  
            main_menu
        end
        if selection=="Make Comment"
            make_comment_menu(article)
        end 
    end

    #make_comment_menu
    def make_comment_menu(article)
        make_new_comment(article)
        refresh_user
        print_article(article)
        comment_menu(article)
    end

    #Make comment
    def make_new_comment(article)
        comment=@@prompt.ask("enter your comment: ")
        refresh_user
        if validate_input(comment)
        Comment.create(comment_content: comment, user_id: @current_user.id, article_id: article.id )
        else
            @@prompt.keypress("You cant input an empty comment!")
        end
    end

    #####################################
    #View comments
    def view_comments
        if @current_user.comments != []
            print_logo
            user_comments = @current_user.map_comment_names
            selection = @@prompt.select("Select a comment to edit/delete", user_comments << "Main menu")
            if !is_main_menu?(selection)
                selected_comment = Comment.find_by(comment_content: selection.split("... ").last)
                manage_comments(selected_comment)
                view_comments
            end
        else
            print_logo
            @@prompt.keypress("\nYou do not have any comments!")
        end
        main_menu
    end

    ###
    #Manage comments
    def manage_comments(comment)
        print_logo
        selection=@@prompt.select("How would you like to manage your comment?","Go to article","Update comment", "Delete comment")
        case selection
        when "Go to article"
            go_to_article(comment.article)
        when "Update comment"
            update_comment(comment)
        when "Delete comment"
            delete_comment(comment)
        end
    end

    #Update comment
    def update_comment(comment)
        comment_update = @@prompt.ask("Comment: ", value: comment.comment_content)
        if validate_input(comment_update)
        comment.update(comment_content: comment_update)
        refresh_user
        else
            @@prompt.keypress("You cannot enter an empty comment!")
        end
    end

    #Delete comment
    def delete_comment(comment)
        comment.destroy
        refresh_user
    end

    #####################################
    #Write an article
    def input_new_article
        article_name = @@prompt.ask("Name your article: ")
        article_content = @@prompt.ask("Write your article: ")
        refresh_user
        if validate_input(article_name) && validate_input(article_content)
            create_new_article(article_name, article_content)
        else
            @@prompt.keypress("You cannot enter an empty article name or content!")
            main_menu
        end
    end

    #Create Article
    def create_new_article(article_name, article_content)
        new_article = Article.create(name: article_name, content: article_content, user_id: @current_user.id)
        refresh_user
        go_to_article(new_article)
    end

    #####################################
     #View users articles
     def select_users_articles
        if @current_user.articles != []
            selection = @@prompt.select("Select one of the articles you have written", @current_user.map_users_articles_names << "Main menu")
            if !is_main_menu?(selection)
            user_articles_menu(selection)
            end
        else
            print_logo
            @@prompt.keypress("\nYou do not have any articles!")
        end
        main_menu
    end

    ###
    #User articles Menu
    def user_articles_menu(article_name)
        selection = @@prompt.select("How would you like to manage your arcticle?", "Go to article", "Update article", "Delete article")
        article = Article.find_article_by_name(article_name)
        case selection
        when "Go to article"
            go_to_article(article)
        when "Update article"
            update_article(article)
        when "Delete article"
            delete_article(article)
        end
    end

    #update article
    def update_article(article)
        article_update = @@prompt.ask("article: ", value: article.content)
        if validate_input(article_update)
        article.update(content: article_update)
        refresh_user
        user_articles_menu(article.name)
        else
            @@prompt.keypress("You cannot enter an empty article!")
            main_menu
        end
    end

    #delete article
    def delete_article(article)
        article.destroy
        refresh_user
        select_users_articles
    end

    #Go to article
    def go_to_article(article)
        print_article(article)
        comment_menu(article)
    end

    #####################################
    def get_fresh_articles #API has a daily limit to how often you can use it, so we will keep this manual.
        Article.populate
        @@prompt.keypress("You are up to date!")
    end

    #####################################
    #Get statistics
    def get_statistics
        print_logo
        #most read article
        puts "\nMost Read Article(s):"
        most_read_article
        #most commented article
        puts "\nMost Commented Article(s):"
        most_commented_article
        #user with most comments
        puts "\nUser(s) With The Most Comments:"
        users_most_comments
        #user with most articles
        puts "\nUser(s) With The Most Articles:"
        users_most_articles
        #users comment count
        puts "\nYour Comment Count:"
        comment_count
        #users article count
        puts "\nYour Article Count:"
        article_count

        @@prompt.keypress("Press any key to go back to the menu")
        main_menu
    end

    #Most read article
    def most_read_article
        articles = Article.most_read_articles
        formatted_articles = ""
        articles.each{|article|  formatted_articles +="#{article.name}: #{article.read_count} view(s)\n"}
        puts formatted_articles
    end

    #Most commented article
    def most_commented_article
        articles = Article.most_commented_articles
        formatted_article = ""
        articles.each{|article| formatted_article += "#{article.name}: #{article.comments.length} comment(s)\n"}
        puts formatted_article
    end

    #Users most comments
    def users_most_comments
        users = User.commented_most
        formatted_comments = ""
        users.each{|user| formatted_comments += "#{user.user_name}: #{user.comments.length} comment(s)\n"}
        puts formatted_comments
    end

    #Users most articles
    def users_most_articles
        users = User.authored_most
        formatted_articles = ""
        users.each{|user| formatted_articles += "#{user.user_name}: #{user.articles.count} article(s)\n"}
        puts formatted_articles
    end

    #users comment count
    def comment_count
        puts "#{@current_user.comment_amount} comment(s)\n"
    end

    #users comment count
    def article_count
        puts "#{@current_user.article_amount} article(s)\n"
    end

    #Misc methods
    #Clears console, called on screen refresh
    def clear_console
        system "clear"
    end

    #Refresh user, called on crud actions for active records sake
    def refresh_user
        @current_user = User.find(@current_user.id)
    end

    #Print logo, called on every menu screen
    def print_logo(sleep_value = 0)
        clear_console
        puts"        ███      ▄█       ████████▄     ▄████████    ".colorize(:color => :white, :background => :light_black)
    sleep(sleep_value)
    puts"    ▀█████████▄ ███       ███   ▀███   ███    ███    ".colorize(:color => :white, :background => :light_black)
    sleep(sleep_value)
    puts"       ▀███▀▀██ ███       ███    ███   ███    ███    ".colorize(:color => :white, :background => :light_black)
    sleep(sleep_value) 
    puts"        ███   ▀ ███       ███    ███  ▄███▄▄▄▄██▀    ".colorize(:color => :white, :background => :light_black) 
    sleep(sleep_value)
    puts"        ███     ███       ███    ███ ▀▀███▀▀▀▀▀      ".colorize(:color => :white, :background => :light_black)
    sleep(sleep_value)   
    puts"        ███     ███       ███    ███ ▀███████████    ".colorize(:color => :white, :background => :light_black)
    sleep(sleep_value) 
    puts"        ███     ███▌    ▄ ███   ▄███   ███    ███    ".colorize(:color => :white, :background => :light_black)
    sleep(sleep_value) 
    puts"       ▄████▀   █████▄▄██ ████████▀    ███    ███    ".colorize(:color => :white, :background => :light_black)
    sleep(sleep_value) 
    puts"                ▀                      ███    ███    ".colorize(:color => :white, :background => :light_black)
    sleep(sleep_value) 
    end

    #Check selection for main_menu
    def is_main_menu?(selection)
        selection == "Main menu"
    end

    #Print article
    def print_article(article)
        print_logo
        puts article.show_article
        article
    end

    #Validates input
    def validate_input(input)
        !input.to_s.strip.empty? #Validate all inputs
    end

    end