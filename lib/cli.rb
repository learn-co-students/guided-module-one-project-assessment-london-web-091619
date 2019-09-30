class CLI
  @@prompt = TTY::Prompt.new

  def run
    greeting
    @user = login
    main_menu
    choose_restaurants.eql?("Add a new restaurant") ? create_restaurant : write_review
  end

  def greeting
    puts "Hello!"
    # @@prompt.select("Looking for food?", %w[Yes No])
  end

  def login
    User.new(name: @@prompt.ask("What should we call you?"))
  end

  def main_menu
    options = ["Show me restaurants"]
    @@prompt.select("How can we help you today?", options)
  end

  def choose_restaurants
    @@prompt.select("x", Restaurant.random_names(10), "Add a new restaurant")
  end
end
