User.destroy_all
Article.destroy_all
Comment.destroy_all

user1 = User.create(user_name: "John",  password: "1")
article1 = Article.create(name: "an article", content: "Some conent")
Comment.create(comment_content: "This is a comment", user_id: user1.id, article_id: article1.id)

Article.populate