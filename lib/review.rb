class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :park
  @@prompt = TTY::Prompt.new

  def park_name
    self.park.name
  end

  def park_location
    self.park.location
  end

  def park_price
    self.park.price
  end

  def park_year_opened
    self.park.year_opened
  end

  def park_size
    self.park.size_in_acres
  end


end
