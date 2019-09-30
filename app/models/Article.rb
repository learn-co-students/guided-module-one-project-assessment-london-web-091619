class Article
    @@all = []
    attr_reader :name, :content

    def initialize(article_hash)
        @name = article_hash[:title]
        @content = article_hash[:content]
        @@all << self
    end

    def self.all
        @@all
    end
end