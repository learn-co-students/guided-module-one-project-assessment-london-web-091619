class Article < ActiveRecord::Base
    has_many :comments
    has_many :users, through: :comments
   
    #used to seed database
    def self.populate
        api = Api.new
        api_data = api.formatdata
        api_data.map{|article| Article.create(article)}
    end


    def self.map_names
        all.map do |article|
            article.name 
        end
    end
end