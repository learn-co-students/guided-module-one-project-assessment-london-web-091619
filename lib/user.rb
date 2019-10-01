class User < ActiveRecord::Base
  has_many :reviews
  has_many :restaurants, through: :reviews

  def restaurant_names
    restaurants.map(&:name)
  end

  def review_select_options(restaurant)
    reviews.select(restaurant: restaurant)
    binding.pry
  end
end
