class Auth
  attr_reader :zomato, :mapquest
  def initialize
    @zomato = "ENTER YOUR ZOMATO API KEY HERE"
    @mapquest = "ENTER YOUR MAPQUEST API KEY HERE"
  end
end
