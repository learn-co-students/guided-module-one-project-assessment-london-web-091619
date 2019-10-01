# coding: utf-8
class CLI
  @@prompt = TTY::Prompt.new

  def run
    response = greeting # greets user, asks whether register or login

    @user = response.eql?("Log in") ? login : register # handles user's choice

    main_menu
  end

  def greeting
    @@prompt.select("Hello!", "Log in", "Register")
  end

  def login
    email = @@prompt.ask("Please enter your email address:")
    User.find_by(email: email)
    # check if a user was actually found
    # if not, ask them to register or add a different email
  end

  def register
    email = @@prompt.ask("Please enter your email address:")
    name = @@prompt.ask("What should we call you?")
    User.create(name: name, email: email)
  end

  def main_menu
    refresh_user

    options = ["Review a restaurant"]
    options << "Delete one of your reviews" unless @user.reviews.empty?
    options << "Exit"
    selection = @@prompt.select("Hi #{@user.name}, how can we help you today?", options)
    menu_selection(selection)
  end

  def refresh_user
    @user = User.find(@user.id)
  end

  def menu_selection(selection)
    case selection
    when "Exit"
      puts "Thank you for using our app!"
    when "Review a restaurant"
      review_restaurant
    when "Delete one of your reviews"
      delete_review
    end
  end

  def review_restaurant
    choice = choose_restaurant

    if choice.eql?("Add a new restaurant")
      new_restaurant = create_restaurant
      write_review(new_restaurant.name)
    else
      write_review(choice)
    end

    main_menu
  end

  def choose_restaurant
    @@prompt.select("x", Restaurant.random_names(10), "Add a new restaurant")
  end

  def create_restaurant
    Restaurant.create(name: @@prompt.ask("What is the restaurant called?"))
  end

  def write_review(restaurant_name)
    restaurant = Restaurant.find_by(name: restaurant_name)
    rating = @@prompt.ask("How many stars would you give #{restaurant.name}? (out of 5)")
    content = @@prompt.ask("Please write a review:")

    Review.create(
      rating: rating,
      content: content,
      restaurant_id: restaurant.id,
      user_id: @user.id
    )
  end

  def delete_review
    chosen_review = choose_user_review
    #"are you sure?"
    #delete

    main_menu
  end

  def choose_user_review
    # todo: two-step review choice (first choose restaurant, then choose review)
    restaurant_name =
      @@prompt.select("Which review do you want to delete?", @user.restaurant_names)

    chosen_restaurant = Restaurant.find_by(name: restaurant_name)

    @user.review_select_options(chosen_restaurant) # should return array of prettified strings for @@prompt.select for each review of chosen restaurant
  end
end
