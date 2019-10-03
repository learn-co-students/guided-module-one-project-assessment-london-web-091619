class CLI
  @@prompt = TTY::Prompt.new
  @@api = API.new

  def run
    puts ""
    puts "🍕 WELCOME TO FOODEE 🍕".center(34).colorize(:red).bold
    puts ""
    user_type = find_user_type

    @user = user_type.eql?("Customer") ? user_login : restaurant_login
    @user.class.eql?(User) ? user_menu : restaurant_menu
  end

  def find_user_type
    @@prompt.select("Are you a customer or a restaurant?", "Customer", "Restaurant")
  end

  def user_login
    email = @@prompt.ask("Please enter your email address:")
    return User.find_by(email: email) if User.find_by(email: email)

    failure_message = "We couldn't find a customer account with that email address. Would you like to try again or register a new account?"
    response = @@prompt.select(failure_message, "Try again", "Register new account")

    response.eql?("Register new account") ? register_user(email) : user_login
  end

  def restaurant_login
    restaurant_name = @@prompt.select("Which restaurant would you like to log in as?", Restaurant.random_names(10))
    Restaurant.find_by(name: restaurant_name)
  end

  def register_user(email)
    name = @@prompt.ask("What should we call you?")
    User.create(name: name, email: email)
  end

  def user_menu
    refresh_user

    options = ["Search for a restaurant", "Review a restaurant"]
    options += ["Delete one of your reviews", "Update one of your reviews"] unless @user.reviews.empty?
    options << "Exit"
    selection = @@prompt.select("Hi #{@user.name}, how can we help you today?", options)
    menu_selection(selection)
  end

  def restaurant_menu
    options = ["Read reviews", "Exit"]
    selection = @@prompt.select("Hi #{@user.name}, how can we help you today?", options)
    if selection.eql?("Read reviews")
      read_customer_reviews
    else
      puts "Thank you for using our app!"
    end
  end

  def refresh_user
    @user = User.find(@user.id)
  end

  def read_customer_reviews
    list_customer_reviews =  @@prompt.select("", @user.reviews_for_prompt)
     confirmation = @@prompt.select("Leave a review for customer", "Yes", "No")
     if confirmation == "Yes"
        write_review_for_customer(list_customer_reviews) #restaurant is able to review
     else 
        restaurant_menu  #takes them back to restaurant menu 
  end
end

  def menu_selection(selection)
    case selection
    when "Exit"
      puts "Thank you for using our app!"
    when "Search for a restaurant"
      search_for_restaurant
    when "Review a restaurant"
      review_restaurant
    when "Update a review"
      update_review
    when "Delete one of your reviews"
      delete_review
    when "Update one of your reviews"
      update_review
    end
  end

  def search_for_restaurant
    query = @@prompt.ask("What are you looking for?")
    restaurants = @@api.search_by_name(query)
    if restaurants
      restaurant = @@prompt.select("", restaurants)
      api_restaurant_action(restaurant)
    else
      puts "Sorry, no restaurants found for that query. Please try again."
      search_for_restaurant
    end
  end

  def api_restaurant_action(restaurant)
    location = restaurant["restaurant"]["location"]
    latitude = location["latitude"]
    longitude = location["longitude"]
    lat_long = latitude + "," + longitude

    choice = @@prompt.select("What would you like to do?", "Get directions", "Go back to main menu")
    choice.eql?("Get directions") ? get_directions(lat_long) : user_menu
  end

  def get_directions(lat_long)
    directions = @@api.direction_list(lat_long)

    unless directions
      puts "\nWe don't have directions for that location, sorry!\n\n"
      search_for_restaurant
    end

    puts ""
    directions.each do |direction|
      puts direction
    end
    puts ""
    @@prompt.select("", "Thanks")
    user_menu
  end

  def review_restaurant
    choice = choose_restaurant

    if choice.eql?("Add a new restaurant")
      new_restaurant = create_restaurant
      write_review(new_restaurant.name)
    else
      write_review(choice)
    end

    user_menu
  end

  def choose_restaurant
    @@prompt.select("", Restaurant.random_names(10), "Add a new restaurant")
  end

  def create_restaurant
    Restaurant.create(name: @@prompt.ask("What is the restaurant called?"))
  end

  def write_review(restaurant_name)
    restaurant = Restaurant.find_by(name: restaurant_name)
    rating = @@prompt.slider("Rating", max: 5, min: 0, step: 0.5, default: 2.5, format: "|:slider| %.1f")
    content = @@prompt.ask("Please write a review:")

    Review.create(
      rating: rating,
      content: content,
      restaurant_id: restaurant.id,
      user_id: @user.id
    )
  end

  def update_review
    chosen_review = choose_user_review("Which review would you like to update?")
    # default value should be previous value
    chosen_review.rating = @@prompt.slider("Rating", max: 5, min: 0, step: 0.5, default: 2.5, format: "|:slider| %.1f")
    chosen_review.content = @@prompt.ask("Please write a new review:")
    chosen_review.save

    user_menu
  end

  def delete_review
    chosen_review = choose_user_review("Which review would you like to delete?")
    # add option to go back to main menu?
    confirm_message = "Are you sure you want to delete this review for #{chosen_review.restaurant.name}"
    chosen_review.destroy if @@prompt.yes?(confirm_message)

    user_menu
  end

  def choose_user_review(message)
    # todo: two-step review choice (first choose restaurant, then choose review)
    @@prompt.select(message, @user.reviews_for_prompt)
  end

  def write_review_for_customer(restaurant_obj)
    rating = @@prompt.slider("Rating", max: 5, min: 0, step: 0.5, default: 2.5, format: "|:slider| %.1f")
    content = @@prompt.ask("Please write a review:")
    
    restaurant_obj.update(:rating_for_customers => rating, :content_for_customers => content)
    
    restaurant_menu
    end
end
