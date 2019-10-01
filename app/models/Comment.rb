class Comment < ActiveRecord::Base
    belongs_to :users
    belongs_to :articles

    def show_user
        user = User.find_by(id: self.user_id)
        user.user_name
    end
end