class User < ActiveRecord::Base
  has_many :reviews
  has_many :restaurants, through: :reviews

  def restaurant_names
    restaurants.map(&:name)
  end

  def reviews_for_prompt
    reviews.each_with_object({}) do |review, obj|
      string = "Restaurant: #{review.restaurant.name}
  Rating: #{review.rating}
  Content: #{review.content}\n"

      obj[string] = review
    end
  end
end
