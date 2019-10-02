class Gelato < ActiveRecord::Base
  has_many :orders
  has_many :users, through: :orders

  def current_stock
    Gelato.all.first.stock
  end
end
