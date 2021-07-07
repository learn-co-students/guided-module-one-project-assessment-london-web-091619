Review.destroy_all
User.destroy_all
Book.destroy_all

user1 = User.create(username: "SarahW", password: "qwerty")
user2 = User.create(username: "TheTami", password: "password1")
user3 = User.create(username: "Lwise", password: "runner90")
user4 = User.create(username: "Ed95", password: "lifter22")
user5 = User.create(username: "ConorS", password: "joker")
user6 = User.create(username: "Andy30", password: "bigreader")

book1 = Book.create(title: "The Siege", page_count: 293)
book2 = Book.create(title: "The Sea", page_count: 200)
book3 = Book.create(title: "Wolf Hall", page_count: 350)
book4 = Book.create(title: "Stardust", page_count: 180)
book5 = Book.create(title: "Tinkers", page_count: 125)
book6 = Book.create(title: "Carrie", page_count: 338)
book7 = Book.create(title: "Bird Box", page_count: 99)


review1 = Review.create(user: user1, book: book1, content: "easy read!", rating: 4)
review2 = Review.create(user: user2, book: book5, content: "Loved this book!", rating: 5)
review3 = Review.create(user: user3, book: book2, content: "didn't enjoy reading this book.", rating: 1)
review4 = Review.create(user: user4, book: book4, content: "fab book to take on holiday!", rating: 5)
review5 = Review.create(user: user5, book: book3, content: "this book was alright.", rating: 3)
review6 = Review.create(user: user6, book: book6, content: "preferred the movie!", rating: 2)
review7 = Review.create(user: user6, book: book7, content: "quick read!", rating: 4)


