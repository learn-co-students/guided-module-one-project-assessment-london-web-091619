class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :book

    def book_title
        self.book.title
    end


end