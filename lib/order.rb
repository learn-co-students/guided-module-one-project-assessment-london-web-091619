class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :gelato

  # quantity of order

  #

end
