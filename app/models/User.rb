class User < ActiveRecord::Base
    has_many :comments, dependent: :destroy #No current functionality to delete a user, so this will do nothing.
    has_many :articles

    def map_comment_names #Formatted to show related comment for each article
        comments.map {|comment| "#{comment.comment_article_names[0]} #{comment.comment_article_names[1]} #{comment.comment_article_names[2]}... #{comment.comment_content}"}
    end

    def map_users_articles_names
        articles.map{|article| article.name}
    end

    def self.commented_most
        most_comments = all.max{|user| user.comments.length}.comments.length
        all.select{|user| user.comments.length == most_comments}
    end

    def self.authored_most
        most_authors = all.max{|user| user.articles.length}.articles.length
        all.select{|user| user.articles.length == most_authors}
    end

    def comment_amount
        comments.length
    end
    
    def article_amount
        articles.length
    end
end  