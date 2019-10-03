class Park < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews
  @@prompt = TTY::Prompt.new


  def self.all_park_ids
    all.map do |parks|
      "#{parks.id}. #{parks.name}"
    end
  end

  def self.all_names
    all.map(&:name)
  end

  def park_rating_amounts
    ratings = self.reviews.map(&:rating)
    @average_rating_for_individual_park = ratings.sum.to_f/ ratings.length.to_f
  end

  def self.park_review_choice
    @park_selection = @@prompt.select("Select the park you would like to review.", self.all_names, "Exit.")
    if @park_selection == "Exit."
      puts "Goodbye, don't forget to bring sunscreen!"
      exit!
    end
    @park_choice = self.find_by(name: @park_selection)
  end

# def self.average_rating
#   @review_selection = @@prompt.select("Select the park you would like to see the average rating for.", Park.all_park_ids, "Exit.")
#   if_choice_is_exit
#   get_id
#   chosen_park = Park.find_by(id: get_id)
#   park_ratings = chosen_park.reviews.map(&:rating)
#   park_average_rating = park_ratings.sum.to_f / park_ratings.length.to_f
#   puts "\n The average rating of this park is: #{park_average_rating.round(1)} stars.
#   \n"
# end


end
