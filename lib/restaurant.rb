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
end
