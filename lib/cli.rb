#create cli class
class Cli
    @@prompt = TTY::Prompt.new

    #Log in with username/password
    def welcome
        print_logo(0.1)
        puts "Welcome to tl;dr news service!"
    selection = @@prompt.select("Choose an option", "Log In", "Sign Up")
    case selection
    when "Log In"
        login
    when "Sign Up"
        sign_up_prompt
    end
    end

    def sign_up_prompt
        print_logo
        user_name = @@prompt.ask("Enter a unique username: ")
        password = @@prompt.mask("Enter a secure password: ")
        sign_up(user_name, password)
    end

    def sign_up(user_name, password)
        if !check_for_duplicate_usernames(user_name)
            User.create(user_name: user_name, password: password)
            validate(user_name, password)
        else sign_up_prompt end
    end

    def check_for_duplicate_usernames(user_name)
        User.find_by(user_name: user_name) 
    end

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


    def login
        username = @@prompt.ask("Please enter your username: ")
        password = @@prompt.ask("Please enter your password: ")
        validate(username, password)
    end

    def validate(username, password)
        set_current_user(username, password)
        if @current_user
            main_menu
        else 
            puts "We could not find your user! Please try again" 
            login
        end
    end

    def set_current_user(username, password)
        @current_user = User.find_by(user_name: username, password: password)
    end
        
    #menu 
    #- choose article from top-headline
    #- View comments

    def main_menu
        print_logo
       selection= @@prompt.select("Choose an option please!", "choose an article","View comments","Write an article","View your articles", "Exit")
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
        when "Exit"
            puts "Goodbye!"
        end
    end

    def input_new_article
        article_name = @@prompt.ask("Name your article: ")
        article_content = @@prompt.ask("Write your article: ")
        create_new_article(article_name, article_content)
    end

    def create_new_article(article_name, article_content)
        new_article = Article.create(name: article_name, content: article_content, user_id: @current_user.id)
        print_article(new_article)
        comment_menu(new_article)
    end

    def select_users_articles
        selection = @@prompt.select("Select one of the articles you have written", @current_user.map_users_articles_names)
        user_articles_menu(selection)
    end

    def user_articles_menu(article)
        selection = @@prompt.select("How would you like to manage your arcticle?", "Go to article", "Update article", "Delete article")
        article = Article.find_by(name: article)
        
        case selection
        when "Go to article"
            go_to_article(article)
        when "Update article"
            article_update = @@prompt.ask("article: ", value: article.content)
            article.update(content: article_update)
            user_articles_menu(article.name)
        when "Delete article"
            article.destroy
            select_users_articles
        end
    end
    
    def go_to_article(article)
        print_article(article)
        comment_menu(article)
    end

    def view_comments
        print_logo
        user_comments = @current_user.map_comment_names
        user_comments << "Main Menu"
        selection = @@prompt.select("Select a comment to edit/delete", user_comments)
        if !is_main_menu?(selection)
            selected_comment = Comment.find_by(comment_content: selection)
            manage_comments(selected_comment)
            view_comments
        end
    end


    def is_main_menu?(selection)
        selection == "Main Menu"
    end


    def select_article
        print_logo
        selection = @@prompt.select("Select an article please!", Article.map_names)
        article = find_article_by_name(selection)
        print_article(article)
    end

    def find_article_by_name(selection)
        Article.find_by(name: selection)
    end

    def print_article(article)
        print_logo
        puts article.show_article
        article
    end

    def comment_menu(article)
     selection=@@prompt.select("would you like to make a comment?","Back","Make Comment") 
        if selection=="Back"  
            main_menu
        end
        if selection=="Make Comment"
            make_comment(article)
            print_article(article)
            comment_menu(article)
        end 
    end

    def make_comment(article)
        comment=@@prompt.ask("enter your comment: ")
        Comment.create(comment_content: comment, user_id: @current_user.id, article_id: article.id )
    end
    

    def manage_comments(comment)
        print_logo
        selection = ""
        selection=@@prompt.select("How would you like to manage your comment?","Go to article","Update comment", "Delete comment")
        case selection
        when "Go to article"
            
            article = Article.find_by(id: comment.article_id)
            print_article(article)
            comment_menu(article.name)
        when "Update comment"
            comment_update = @@prompt.ask("Comment: ", value: comment.comment_content)
            comment.update(comment_content: comment_update)
        when "Delete comment"
            comment.destroy
        end
    end

    def clear_console
        system "clear"
    end



    #input from user: what they would like to comment
    #use active record to create a new instance of comment andassign the user id and comment to it
    end