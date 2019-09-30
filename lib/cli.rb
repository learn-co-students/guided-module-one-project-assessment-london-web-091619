class CLI
  @@prompt = TTY::Prompt.new

  def run
    return if greeting.eql?("No")

    @user = login
    main_menu
    choice = choose_restaurant
    if choice.eql?("Add a new restaurant")
      new_restaurant = create_restaurant
      write_review(new_restaurant.name)
    else
      write_review(choice)
    end
  end

  def greeting
    puts "Hello!"
    @@prompt.select("Looking for food?", %w[Yes No])
  end

  def login
    User.new(name: @@prompt.ask("What should we call you?"))
  end

  def main_menu
    options = ["Review a restaurant"]
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
      # add user id
      rating: rating, content: content, restaurant_id: restaurant.id
    )
  end
end
