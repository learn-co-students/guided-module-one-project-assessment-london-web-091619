class CLI
    @@prompt = TTY::Prompt.new
    #make a run method to welcome user, and gives the option of signin or login
    def greeting
        puts "Welcome to my Book Review App!".on_blue
        choice = @@prompt.select("What would you like to do?", "> Signup", "> Login")
        if choice == "> Signup"
            signup
            main_menu
        elsif choice == "> Login"
            @current_user = login
            if @current_user != nil
                main_menu
            else
                puts "Sorry, we couldn't find those details. Please try again.".red
                greeting
            end
        end
    end

    #method for user to login with username and password. call on the prompt ask.
    def login
        username = @@prompt.ask("Username: ")
        password = @@prompt.mask("Password: ")
        return User.find_by(username: username, password: password)
    end

    #method for a new user to sign up with username and password
    def signup
        username = @@prompt.ask("Please enter a username: ")
        password = @@prompt.ask("Please enter a password: ")
        User.create(username: username, password: password)
        @current_user = User.find_by(username: username, password: password)
    end

    def main_menu
        options = @@prompt.select("Please click one of the following options", 
        "> My Reviews", "> Create a new Book Review", "> Update a Review", "> Add a New Book", 
        "> Delete a Review", "> Exit")
        case options 
        when  "> My Reviews"
            review_list
        when "> Create a new Book Review"
            review_book
        when "> Update a Review"
            update_reviews
        when "> Add a New Book"
            add_new_book
        when "> Delete a Review"
            delete_review
        when "> Exit"
            exit
        end
        main_menu
    end

    #method for user to see all of their reviews
    def review_list
        puts "You have written #{@current_user.num_of_reviews} reviews."
        puts "Your average rating is: #{@current_user.average_rating}."
        puts @current_user.all_review_data 
    end

    #list all the books and let the user create a new review for the selected book
    def review_book
        collection = @@prompt.select("Which book do you want to review?", Book.all_titles)
        selected_book = Book.find_by(title: collection)
        content = @@prompt.ask("Please enter your review content: ")
        rating = @@prompt.slider('Rating', max: 5, step: 1)
        Review.create(content: content, rating: rating, book_id: selected_book.id, user_id: @current_user.id)
        @current_user = User.find_by(id: @current_user.id)
        puts "Your review has been submitted!"
    end


    #method for the user to update their reviews
    def update_reviews
        selection = @@prompt.select("Which Review do you want updated?", @current_user.all_review_data)
        selected_review = Review.find_by(id: selection.split.last.to_i)
        new_content = @@prompt.ask("Please update your review content: ")
        new_rating = @@prompt.slider('Rating', max: 5, step: 1)
        selected_review.update(content: new_content, rating: new_rating)
        @current_user = User.find_by(id: @current_user.id)
        puts "Your review has been updated!"
    end

    #method that will let the user add a new book
    def add_new_book
        book_title = @@prompt.ask("Please enter the new book title: ")
        page_num = @@prompt.ask("Please enter the number of pages: ")
        Book.create(title: book_title, page_count: page_num)
        puts "New Book has been added!"
    end


    #method for the user to delete a review
    def delete_review
        removed = @@prompt.select("Which Review do you want to delete?", @current_user.all_review_data)
        deleted_review = Review.find_by(id: removed.split.last.to_i)
        deleted_review.destroy
        @current_user = User.find_by(id: @current_user.id)
        puts "Review has been deleted!"
    end



end