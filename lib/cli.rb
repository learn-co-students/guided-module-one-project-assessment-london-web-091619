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
        @current_user = User.find_by(user_name: username, password: password)

    if @current_user
        puts "you are logged in"
        main_menu
    else 
        puts "We could not find your user! Please try again" 
        login
    end
end
        
    #menu 
    #- choose article from top-headline
    #- View comments

    def main_menu
       selection= @@prompt.select("Choose an option please!", ["choose an article","View comments"])
        if selection == "choose an article"
            select_article
            comment_menu
        elsif selection == "View comments"
            view_comments
        end
        main_menu
    end

    def view_comments
        user_comments = @current_user.map_comment_names
        selection = @@prompt.select("Select a comment to edit/delete", user_comments)
    end


    def select_article
        selection = @@prompt.select("Select an article please!", Article.map_names)
        @article = Article.find_by(:name == selection)
        puts @article.content
    end

    def comment_menu
     selection=@@prompt.select("would you like to exit or make a comment?","exit","comment") 
        if selection=="exit"  
            main_menu
        end
        if selection=="comment"
            comment=@@prompt.ask("enter your comment: ")
            Comment.create(comment_content: comment, user_id: @current_user.id, article_id: @article.id )
        end
    end

    #input from user: what they would like to comment
    #use active record to create a new instance of comment andassign the user id and comment to it
    
end