class API
  attr_reader :header
  def initialize
    auth = Auth.new
    @header = {
      "user-key": auth.zomato
    }
  end

  def search_by_name(query)
    response = HTTParty.get("https://developers.zomato.com/api/v2.1/search?q=#{query}", headers: header)
    restaurants_for_prompt(response)
  end

  def restaurants_for_prompt(response)
    JSON.parse(response.body)["restaurants"].each_with_object({}) do |restaurant, obj|
      name = restaurant["restaurant"]["name"]
      location = restaurant["restaurant"]["location"]["locality_verbose"]
      string = name + " - " + location
      obj[string] = restaurant
    end
  end
end
