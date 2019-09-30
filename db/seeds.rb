User.create(user_name: "John",  password: "1")
User.create(user_name: "John 2", password: "1")
User.create(user_name: "John 3", password: "1")

Comment.create(comment_content: "This is a comment", user_id: 1)