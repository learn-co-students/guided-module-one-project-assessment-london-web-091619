class Restaurant < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews

  def self.random_names(num)
    random_names = []
    num.times do
      random_names << all.sample.name
    end
    random_names.uniq
  end

  # def reviews_for_prompt
  #   review_data = ""
  #   reviews.each do |review|
  #     review_data += "\n#{review.user.name} | #{review.rating} #{'*' * review.rating.round}\n#{review.content}\n"
  #   end
  # end

  def reviews_for_prompt
    reviews.each_with_object({}) do |review, obj|
      string = "#{review.user.name} | #{review.rating} #{'*' * review.rating.round}\n#{review.content}\n\n"
      obj[string] = review
      # binding.pry
    end
  end
end
