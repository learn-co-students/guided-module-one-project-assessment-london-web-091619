class Article < ActiveRecord::Base
    has_many :comments, dependent: :destroy
    belongs_to :user
   
    #used to populates database from API
    def self.populate
        api = Api.new
        api_data = api.formatdata
        api_data.map do |article| 
            if Article.find_by(name: article[:name]) == nil #Check for duplicates, API only refreshes every 20 minutes or so.
                if !article[:content].to_s.strip.empty? #Ignores empty articles.
                Article.create(article)
                else
                    return false
                end
            end
        end
    end

    def self.map_names
        all.map do |article|
            article.name 
        end
    end

    def prepare_article
        if self.user == nil
        "
    Title: #{self.name}
    Content: #{self.content}
        --------
        Comments
        --------
"
        else
            "
    Author: #{self.user.user_name}
    Title: #{self.name}
    Content: #{self.content}
        --------
        Comments
        --------
"
        end

    end

    def show_article
        comments = find_article_comments
        article = prepare_article
        comments.each {|comment| article += "#{comment.show_user}: #{comment.comment_content}\n"}
        article
    end

    def find_article_comments
        Comment.all.select{|comment| comment.article_id == self.id}
    end

    def self.find_article_by_name(selection)
        find_by(name: selection)
    end

    def self.most_read_articles
        max_read = all.maximum("read_count")
        all.select{|article| article.read_count == max_read}
    end

    def self.most_commented_articles
        max_comments = all.max{|article| article.comments.length}.comments.length
        all.select{|article| article.comments.length == max_comments}
    end

    

end