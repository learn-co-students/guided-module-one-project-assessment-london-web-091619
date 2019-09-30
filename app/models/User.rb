class User < ActiveRecord::Base
    has_many :comments
    has_many :articles, through: :comments

    def find_comments
        Comment.all.select{|comment| comment.user_id == self.id}
    end

    def map_comment_names
        find_comments.map {|comment| comment.comment_content}
    end
end