# coding: utf-8
class CLI
  @@prompt = TTY::Prompt.new

  def run
    response = greeting

    @user = response.eql?("Log in") ? login : register

    p @user

    menu_selection = main_menu
    if menu_selection.eql?("Review a restaurant")
      choice = choose_restaurant
      if choice.eql?("Add a new restaurant")
        new_restaurant = create_restaurant
        write_review(new_restaurant.name)
      else
        write_review(choice)
      end
    elsif menu_selection.eql?("Delete one of your reviews")
      delete_review
    end
  end

  def greeting
    @@prompt.select("Hello!", "Log in", "Register")
  end

  def register
    email = @@prompt.ask("Please enter your email address:")
    name = @@prompt.ask("What should we call you?")
    User.create(name: name, email: email)
  end

  def login
    email = @@prompt.ask("Please enter your email address:")
    User.find_by(email: email)
    # check if a user was actually found
    # if not, ask them to register or add a different email
  end

  def main_menu
    # options = ["Review a restaurant", "Delete one of your reviews"]
    options = ["Review a restaurant"]
    options << "Delete one of your reviews" unless @user.restaurants.empty?
    @@prompt.select("How can we help you today?", options)
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
    choice = choose_user_review
    puts choice
    #review details are shown
    #"are you sure?"
    #delete
  end

  def choose_user_review
    restaurant_name =
      @@prompt.select("Which review do you want to delete?", @user.restaurant_names)
    #list all of the user’s reviews
    #user can choose a review
    Restaurant.find_by(name: restaurant_name)
  end
end
