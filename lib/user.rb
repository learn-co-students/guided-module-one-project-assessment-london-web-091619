class User < ActiveRecord::Base
    has_many :reviews
    has_many :books, through: :reviews

    def all_review_data
        self.reviews.map do |review|
           "                              
            Book: #{review.book_title}
            Content: #{review.content}
            Rating: #{review.rating}
            ----------------------- #{review.id}"
        end
    end

    #method that returns usernames in descsending order
    def self.ordered_users
        all.order(username: :desc)
    end

    #method to find all the usernames
    def self.find_by_username
        all.select(:username)
    end

end
