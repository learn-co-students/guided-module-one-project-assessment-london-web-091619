#Parks and Ruby Domain, doing Leslie Knope proud.
class CLI
  @@prompt = TTY::Prompt.new


  def run
    puts "Welcome to Parks and Ruby!\nPlease login with your account details:"
    @current_user = login
  end


  def login
    @current_user = User.find_user_by_name_and_password
    login_validation
  end

  def login_validation
    if @current_user
      main_menu
    else
      puts "Sorry, that username/password combo wasn't recognised. Please try again."
      login
    end
  end


  def main_menu
    @menu_selection = @@prompt.select("What would you like to do today?", "See my reviews.", "Review a park.", "Delete a review.", "Update a review.", "Exit.")
    menu_choice
  end

  def menu_choice
    case @menu_selection
    when "See my reviews."
      print_user_reviews
    when "Review a park."
      review_parks
    when "Delete a review."
      park_delete_review
    when "Update a review."
      park_update_review
    else
      if_choice_is_exit
    end
    main_menu
  end

  def if_choice_is_exit
    if @park_selection == "Exit." || @review_selection == "Exit." || @menu_selection == "Exit."
      puts "Goodbye, don't forget to bring sunscreen!"
      exit!
    end
  end

  def print_user_reviews
    puts @current_user.all_user_reviews
  end


  def review_parks
    park_new_review
    review_prompt
    create_review_for_park
  end



  def park_new_review
    @park_selection = @@prompt.select("Select the park you would like to review.", Park.all_names, "Exit.")
    @park_choice = Park.find_by(name: @park_selection)
    if_choice_is_exit
  end


  def get_review_id
    @review_id = @review_selection.partition(".").first
    @review_id_int = @review_id.to_i
  end


  def create_review_for_park
    Review.create(content: @content, rating: @rating.to_i, park_id: @park_choice.id, user_id: @current_user.id)
    puts "Your review has been created."
    @current_user = User.find(@current_user.id)
    main_menu
  end

  def find_review_by_id
    Review.find_by(id:@review_id_int)
  end

  def review_prompt
    @content = @@prompt.ask("Please enter content of review: ")
    @rating = @@prompt.ask("Please enter rating of review (1-5): ")
  end

  def park_delete_review
    @review_selection = @@prompt.select("Select the park you would like to delete your review for.", @current_user.all_user_reviews, "Exit.")
    if_choice_is_exit
    get_review_id
    review_to_delete = find_review_by_id
    review_to_delete.delete
    puts "Your review has been deleted."
    @current_user = User.find(@current_user.id)
    main_menu
  end


  def park_update_review
    @review_selection = @@prompt.select("Select the park review you would like to update.", @current_user.all_user_reviews, "Exit.")
    if_choice_is_exit
    get_review_id
    updating_review = find_review_by_id
    review_prompt
    updating_review.update(content: @content,rating: @rating)
    puts "Your review has been updated"
    @current_user = User.find(@current_user.id)
    main_menu
  end
end

#work through refactoring, switch case ,average top 3 reviews, average rating, top 3, most reviews.
#Greeting of Leslie Knopes face or something? Maybe Parks and Rec Logo or something
#Stretch goals - Find park by rating, price, get average rating of parks, make console puts out links for
#the parks on google maps or wikipedia or something along those lines.
