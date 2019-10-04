class User < ActiveRecord::Base
has_many :reviews
has_many :parks, through: :reviews
@@prompt = TTY::Prompt.new

  def all_user_reviews
    self.reviews.map do |review|
      "#{review.id}.--------------------------------------\n
        #{review.park_name}
        Year Opened: #{review.park_year_opened}
        Location: #{review.park_location}
        Size in Acres: #{review.park_size}
        Price: #{review.park_price}
        \n
        #{review.content}
        #{review.rating} Stars\n
      "
    end
  end

  def self.find_user_by_name_and_password
    @main_menu_choice = @@prompt.select("Choose an option.", "Sign in.","Sign up.", "Exit.")
    if @main_menu_choice == "Sign in."
      @username = @@prompt.ask("Please enter your username: ")
      @password = @@prompt.mask("Please enter your password: ")
    all.find_by(username: @username, password: @password)
    elsif @main_menu_choice == "Sign up."
      @new_username = @@prompt.ask("Please enter a username: ")
      @new_password = @@prompt.mask("Please create your password: ")
      self.create(username: @new_username, password: @new_password)
    else
      puts "Aww :(. Gone so soon. Farewell.
      \n"
    exit!
    end
  end

  def find_num_reviews
    self.reviews.count
  end

  def ratings
    self.reviews.map(&:rating).sum
  end

  def average_rating_for_user
    @average_given_rating = ratings.to_f / find_num_reviews.to_f
    @average_given_rating.round(2)
  end

end
