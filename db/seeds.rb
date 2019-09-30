require_relative "../config/environment"
require "faker"

50.times do
  Restaurant.create(
    name: Faker::Restaurant.name,
    location: Faker::Address.street_address
  )
end

50.times do
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email
  )
end

50.times do
  Review.create(
    restaurant_id: Restaurant.all.sample.id,
    user_id: User.all.sample.id,
    rating: rand(1.0..5.0).round(1),
    content: Faker::Restaurant.review
  )
end
