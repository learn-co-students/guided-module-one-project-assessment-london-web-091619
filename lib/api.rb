class API
  attr_reader :header
  def initialize
    @@auth = Auth.new
    @header = {
      "user-key": @@auth.zomato
    }
  end

  def search_by_name(query)
    HTTParty.get("https://developers.zomato.com/api/v2.1/search?q=#{query}", headers: header)
  end
end
