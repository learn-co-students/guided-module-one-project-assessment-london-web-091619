class Book < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    def self.all_titles
        all.map { |book| book.title }
    end

    #method to see all the reviews 
    def self.all_reviews
        all.map { |book| book.reviews }
    end

    #method to sort books alphabetically
    def self.alphabetical_order
        all.order(:title)
    end


end