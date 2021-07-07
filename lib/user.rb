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

    def num_of_reviews
        self.reviews.count
    end

    def average_rating
        status = self.reviews.map { |review| review.rating }.sum
        average = status.to_f / num_of_reviews.to_f
        average.round(2)
    end

end
