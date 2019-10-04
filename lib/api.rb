class API
  attr_reader :header, :mapquest_key
  def initialize
    auth = Auth.new
    @mapquest_key = auth.mapquest
    @header = {
      "user-key": auth.zomato
    }
  end

  def search_by_name(query)
    response = HTTParty.get("https://developers.zomato.com/api/v2.1/search?q=#{query}", headers: header)
    restaurants_for_prompt(response)
  end

  def restaurants_for_prompt(response)
    return false if response.body.eql?("\n") || JSON.parse(response.body)["restaurants"].empty?

    JSON.parse(response.body)["restaurants"].each_with_object({}) do |restaurant, obj|
      name = restaurant["restaurant"]["name"]
      location = restaurant["restaurant"]["location"]["locality_verbose"]
      string = name + " - " + location
      obj[string] = restaurant
    end
  end

  def direction_list(lat_long)
    origin_lat_long = "51.5203575,-0.0875923"
    url = "http://www.mapquestapi.com/directions/v2/route?key=#{mapquest_key}&from=#{origin_lat_long}&to=#{lat_long}"
    response = HTTParty.get(url)
    return false if response["info"]["statuscode"].eql?(402)

    directions = JSON.parse(response.body)["route"]["legs"].first
    direction_list = [directions["origNarrative"]]

    direction_list += directions["maneuvers"].map do |maneuver|
      maneuver["narrative"]
    end
    direction_list.pop
    direction_list << "Bon appétit!"
  end
end
