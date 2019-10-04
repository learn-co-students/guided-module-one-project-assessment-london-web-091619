Review.destroy_all
Park.destroy_all
User.destroy_all

park1 = Park.create(name: "Victoria Park",location: "Tower Hamlets", year_opened: 1845 , size_in_acres: 213, price: 0)
park2 = Park.create(name: "St James Park" ,location: "Westminster", year_opened: 1603 , size_in_acres: 56.8, price: 0)
park3 = Park.create(name: "Kew Gardens" ,location: "Richmond", year_opened: 1759 , size_in_acres: 300, price: 16.50)
park4 = Park.create(name: "Green Park",location: "Green Park", year_opened: 1820 , size_in_acres: 47 , price: 0)
park5 = Park.create(name: "Battersea Park",location: "Battersea", year_opened: 1858 , size_in_acres: 200 , price: 0)
park6 = Park.create(name: "Postmans Park",location: "King Edward ST", year_opened: 1880 , size_in_acres: 0.67 , price: 0)
park7 = Park.create(name: "Holland Park",location: "Kensington", year_opened: 1952 , size_in_acres: 54 , price: 0)



user1 = User.create(username: "Luke",password: "password1")
user2 = User.create(username: "John",password: "password2")
user3 = User.create(username: "Kane",password: "password3")
user4 = User.create(username: "Marco",password: "password4")
user5 = User.create(username: "Leslie",password: "password5")
user6 = User.create(username: "Connor",password: "password6")
user7 = User.create(username: "Sarah",password: "password7")
user8 = User.create(username: "1",password: "1")


review1 = Review.create(park_id: park1.id,user_id: user1.id, rating: 5, content: "The greenest grass Ive ever seen.")
review2 = Review.create(park_id: park1.id, user_id: user2.id, rating: 4, content: "Great buzz about the place.")
review3 = Review.create(park_id: park3.id, user_id: user3.id, rating: 5, content: "Well worth the price.")
review4 = Review.create(park_id: park4.id, user_id: user4.id, rating: 3, content: "So nice and well looked after.")
review5 = Review.create(park_id: park3.id, user_id: user2.id, rating: 4, content: "No rubbish anywhere, nice.")
review6 = Review.create(park_id: park2.id, user_id: user2.id, rating: 5, content: "So nice and well looked after.")
review7 = Review.create(park_id: park3.id, user_id: user4.id, rating: 3, content: "Could spend hours in there.")
review8 = Review.create(park_id: park3.id, user_id: user3.id, rating: 5, content: "Its so worth the price.")
review9 = Review.create(park_id: park1.id, user_id: user1.id, rating: 5, content: "The greenest grass Ive ever seen.")
review10 = Review.create(park_id: park7.id, user_id: user1.id, rating: 4, content: "Great buzz about the place.")
review11 = Review.create(park_id: park7.id, user_id: user7.id, rating: 5, content: "Well worth the price.")
review12 = Review.create(park_id: park5.id, user_id: user6.id, rating: 3, content: "So nice and well looked after.")
review13 = Review.create(park_id: park6.id, user_id: user6.id, rating: 4, content: "No rubbish anywhere, nice.")
review14 = Review.create(park_id: park3.id, user_id: user5.id, rating: 5, content: "So nice and well looked after.")
review15 = Review.create(park_id: park5.id, user_id: user4.id, rating: 3, content: "Could spend hours in there.")
review16 = Review.create(park_id: park6.id, user_id: user2.id, rating: 5, content: "Its so worth the price.")
review17 = Review.create(park_id: park1.id, user_id: user8.id, rating: 5, content: "Greatness.")
