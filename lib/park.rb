class Park < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews
  @@prompt = TTY::Prompt.new


  def self.all_park_ids
    all.map do |parks|
      "#{parks.id}. #{parks.name}"
    end
  end

  def self.all_names
    all.map(&:name)
  end

  def self.park_review_choice
    @park_selection = @@prompt.select("Select the park you would like to review.", self.all_names, "Exit.")
    if @park_selection == "Exit."
      puts "Goodbye, don't forget to bring sunscreen!"
      exit!
    end
    @park_choice = self.find_by(name: @park_selection)
  end

end
