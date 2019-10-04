class Book < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    def self.all_titles
        all.map { |book| book.title }
    end

end