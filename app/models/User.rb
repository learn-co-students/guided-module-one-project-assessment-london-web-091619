class User < ActiveRecord::Base
    has_many :comments
    has_many :articles

    def map_comment_names
        comments.map {|comment| comment.comment_content}
    end

    def map_users_articles_names
        articles.map{|article| article.name}
    end
end