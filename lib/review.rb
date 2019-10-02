class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :book

    def book_title
        self.book.title
    end

    #method that returns the highest rated review
    def self.highest_rating
        self.maximum(:rating)
    end

    def self.lowest_rating
        self.minimum(:rating)
    end

    #method to return the average review rating
    def self.average_rating
        all.average(:rating).round
    end


    def self.ratings_sum
        sum(:rating)
    end

    #method that returns review instances that have a rating of 5
    def self.popular_ratings
        where("rating = 5")
    end

    #method to return the number of reviews
    def self.num_of_reviews
        all.count(:rating)
    end

    def self.longest_review
        all.maximum(:content).length
    end

end