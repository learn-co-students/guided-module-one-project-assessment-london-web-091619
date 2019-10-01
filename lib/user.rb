class User < ActiveRecord::Base
  has_many :reviews
  has_many :restaurants, through: :reviews

  def restaurant_names
    restaurants.map(&:name)
  end

  def reviews_for_prompt
    reviews.map do |review|
      "Restaurant: #{review.restaurant.name}
  Rating: #{review.rating}
  Content: #{review.content}\n"
      # binding.pry
    end
  end
end
