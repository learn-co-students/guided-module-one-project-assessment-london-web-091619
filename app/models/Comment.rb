class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :article

    def show_user
        user = User.find_by(id: self.user_id)
        user.user_name
    end

    def comment_article_names
        article.name.split
    end
   
end