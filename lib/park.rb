class Park < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews
  @@prompt = TTY::Prompt.new

  def self.all_names
    all.map(&:name)
  end

  def self.all_locations
    all.map(&:location)
  end

  def self.park_sizes
    all.map(&:size_in_acres)
  end

  def self.all_reviews
    all.map(&:reviews)
  end

  def self.all_id
    all.map(&:id)
  end

  def self.park_review_choice
    @park_selection = @@prompt.select("Select the park you would like to review.", Park.all_names, "Exit.")
    @park_choice = self.find_by(name: @park_selection)
  end

  # def self.create_review
  #   self.create(content: @content, rating: @rating.to_i, park_id: @park_choice.id, user_id: @current_user.id)
  #   puts "Your review has been created."
  #   @current_user = User.find(@current_user.id)
  # end

  # def self.find_user_by_name_and_password
  #   @username = @@prompt.ask("Please enter your username: ")
  #   @password = @@prompt.mask("Please enter your password: ")
  #   all.find_by(username: @username, password: @password)
  # end



end
