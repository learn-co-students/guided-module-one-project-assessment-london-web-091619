class Cli
    @@prompt = TTY::Prompt.new
    #####################################
    #Welcome
    def welcome
        print_logo(0.1)
        puts "Welcome to tl;dr news service!"
        selection = @@prompt.select("Log in or Sign up!", "Log In", "Sign Up")    
        case selection
            when "Log In"
                login
            when "Sign Up"
                sign_up_prompt
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
        if !check_for_duplicate_usernames(user_name)
            create_new_user(user_name, password)
            set_current_user(user_name, password)
            main_menu
        else 
            sign_up_prompt 
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
            @@prompt.keypress("We could not find your user! Please press enter to try again") 
            welcome
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
       selection= @@prompt.select("Choose an option please!", "choose an article","View comments","Write an article","View your articles", "Get fresh articles", "Exit")
        case selection 
        when "choose an article"
            article = select_article
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
        when "Exit"
            abort("Goodbye!")
        end
    end

    ###
    #Choose an article
    def select_article
        print_logo
        selection = @@prompt.select("Select an article please!", Article.map_names)
        article = Article.find_article_by_name(selection)
        print_article(article)
    end

    ##
    #Comment Menu
    def comment_menu(article)
        selection=@@prompt.select("would you like to make a comment?","Back","Make Comment") 
        if selection=="Back"  
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
        Comment.create(comment_content: comment, user_id: @current_user.id, article_id: article.id )
    end

    #####################################
    #View comments
    def view_comments
        if @current_user.comments != []
            print_logo
            user_comments = @current_user.map_comment_names
            selection = @@prompt.select("Select a comment to edit/delete", user_comments << "Main menu")
            if !is_main_menu?(selection)
                selected_comment = Comment.find_by(comment_content: selection)
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
        comment.update(comment_content: comment_update)
        refresh_user
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
        create_new_article(article_name, article_content)
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
        article.update(content: article_update)
        refresh_user
        user_articles_menu(article.name)
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
        puts"        ███      ▄█       ████████▄     ▄████████" 
    sleep(sleep_value)
    puts"    ▀█████████▄ ███       ███   ▀███   ███    ███" 
    sleep(sleep_value)
    puts"       ▀███▀▀██ ███       ███    ███   ███    ███"
    sleep(sleep_value) 
    puts"        ███   ▀ ███       ███    ███  ▄███▄▄▄▄██▀" 
    sleep(sleep_value)
    puts"        ███     ███       ███    ███ ▀▀███▀▀▀▀▀"
    sleep(sleep_value)   
    puts"        ███     ███       ███    ███ ▀███████████"
    sleep(sleep_value) 
    puts"        ███     ███▌    ▄ ███   ▄███   ███    ███"
    sleep(sleep_value) 
    puts"       ▄████▀   █████▄▄██ ████████▀    ███    ███"
    sleep(sleep_value) 
    puts"                ▀                      ███    ███"
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
        input.to_s.strip.empty? #Validate all inputs
    end
    
    end