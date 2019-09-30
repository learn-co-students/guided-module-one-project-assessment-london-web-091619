class Comment < ActiveRecord::Base
    #fill belongs/has_many - once migrations done
    belongs_to :user
end