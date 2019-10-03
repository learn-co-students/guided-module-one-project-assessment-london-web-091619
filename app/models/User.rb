class User < ActiveRecord::Base
    has_many :comments, dependent: :destroy #No current functionality to delete a user, so this will do nothing.
    has_many :articles

    def map_comment_names
        comments.map {|comment| "#{comment.comment_article_names[0]} #{comment.comment_article_names[1]} #{comment.comment_article_names[2]}... #{comment.comment_content}"}
    end

    def map_users_articles_names
        articles.map{|article| article.name}
    end
end