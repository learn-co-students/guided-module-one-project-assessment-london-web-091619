class User < ActiveRecord::Base
    #fill belongs/has_many - once migrations done
    has_many :comment
end