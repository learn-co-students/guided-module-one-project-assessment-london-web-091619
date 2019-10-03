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
    #@main_menu_choice = @@prompt.select("Wnat to sign in or exit?", "Sign in.", "Exit.")
    @username = @@prompt.ask("Please enter your username: ")
    @password = @@prompt.mask("Please enter your password: ")
    all.find_by(username: @username, password: @password)
  end

end
