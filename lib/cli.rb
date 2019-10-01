#create cli class
class Cli
    @@prompt = TTY::Prompt.new

    #Log in with username/password
    def login
        username = @@prompt.ask("Please enter your username: ")
        password = @@prompt.ask("Please enter your password: ")
        validate(username, password)
    end

    def validate(username, password)
        set_current_user(username, password)
        if @current_user
            puts "you are logged in"
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
        clear_console
       selection= @@prompt.select("Choose an option please!", "choose an article","View comments", "Exit")
        if selection == "choose an article"
            article = select_article
            comment_menu(article)
            main_menu
        elsif selection == "View comments"
            view_comments
            main_menu
        #write article  
        elsif selection == "Exit"
            puts "Goodbye!"
        end
    end

    def view_comments
        clear_console
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
        clear_console
        selection = @@prompt.select("Select an article please!", Article.map_names)
        article = Article.find_by(name: selection)
        clear_console
        puts article.show_article
        article
    end

    def comment_menu(article)
     selection=@@prompt.select("would you like to exit or make a comment?","Back","Make Comment") 
        if selection=="Back"  
            return
        end
        if selection=="Make Comment"
            make_comment(article)
        end 
    end

    def make_comment(article)
        comment=@@prompt.ask("enter your comment: ")
        Comment.create(comment_content: comment, user_id: @current_user.id, article_id: article.id )
    end
    

    def manage_comments(comment)
        clear_console
        selection = ""
        selection=@@prompt.select("How would you like to manage your comment?","Update comment", "Delete comment")
        if selection == "Update comment"
            comment_update = @@prompt.ask("Comment: ", value: comment.comment_content)
            comment.update(comment_content: comment_update)
        elsif selection == "Delete comment"
            comment.destroy
        end
    end

    def clear_console
        system "clear"
    end



    #input from user: what they would like to comment
    #use active record to create a new instance of comment andassign the user id and comment to it
    
end