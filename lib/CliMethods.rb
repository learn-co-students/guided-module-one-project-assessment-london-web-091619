class CliMethods
@@prompt = TTY::Prompt.new

  def clear_console
    system "clear"
  end

  def print_user_reviews
    puts "You have #{@current_user.find_num_reviews} reviews."

    puts "Average review given = #{@current_user.average_rating_for_user}"
    puts @current_user.all_user_reviews
  end


  def review_parks
    park_new_review
    review_prompt
    create_review_for_park
  end

  def park_new_review
    @park_choice = Park.park_review_choice
    if_choice_is_exit
  end

  def get_id
    @id = @review_selection.partition(".").first
    @id_int = @id.to_i
  end

  def find_review_by_id
    Review.find_by(id:@id_int)
  end

  def review_prompt
    @content = @@prompt.ask("Please enter content of review: ")
    @rating = @@prompt.ask("Please enter rating of review (0-5 stars): ").to_i
  end

  def average_rating
    @review_selection = @@prompt.select("Select the park you would like to see the average rating for.", Park.all_park_ids, "Exit.")
    if_choice_is_exit
    get_id
    chosen_park = Park.find_by(id: get_id)
    park_ratings = chosen_park.reviews.map(&:rating)
    park_average_rating = park_ratings.sum.to_f / park_ratings.length.to_f
    puts "\n The average rating of this park is: #{park_average_rating.round(1)} stars.
    \n"
  end

  def create_review_validation
    if @rating >= 0 && @rating <= 5 && @content && @rating = Integer
    find_review_by_id.update(content: @content,rating: @rating)
    puts "Your review has been created"
    else
    puts "IT MUST BE BETWEEN 0 & 5 STARS.
    \n"
    review_prompt
    end
  end

  def create_review_for_park
    Review.create(content: @content, rating: @rating.to_i, park_id: @park_choice.id, user_id: @current_user.id)
    if_choice_is_exit
    puts "Your review has been created."
    @current_user = User.find(@current_user.id)
    main_menu
  end

  def park_delete_review
    @review_selection = @@prompt.select("Select the review you would like to delete.", @current_user.all_user_reviews, "Exit.")
    if_choice_is_exit
    get_id
    find_review_by_id.delete
    puts "Your review has been deleted."
    @current_user = User.find(@current_user.id)
    main_menu
  end

  def update_rating_validation
    if @rating >= 0 && @rating <= 5 && @content
    find_review_by_id.update(content: @content,rating: @rating)
    @current_user = User.find(@current_user.id)
    puts "Your review has been updated"
    else
    puts "IT MUST BE BETWEEN 0 & 5 STARS.
    \n"
    review_prompt
    end
  end

  def park_update_review
    @review_selection = @@prompt.select("Select the park review you would like to update.", @current_user.all_user_reviews, "Exit.")
    if_choice_is_exit
    get_id
    review_prompt
    update_rating_validation
    main_menu
  end
end
