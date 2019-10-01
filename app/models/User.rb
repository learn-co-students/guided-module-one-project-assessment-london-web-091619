class User < ActiveRecord::Base
    has_many :comments
    has_many :articles#, through: :comments

    def find_comments
        Comment.all.select{|comment| comment.user_id == self.id}
    end

    def map_comment_names
        find_comments.map {|comment| comment.comment_content}
    end

    def find_users_articles
        Article.all.select{|article| self.id == article.user_id}
    end

    def map_users_articles_names
        find_users_articles.map{|article| article.name}
    end
end