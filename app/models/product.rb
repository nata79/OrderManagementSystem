class Product < ActiveRecord::Base
  monetize :net_price_pennies, as: 'net_price'

  validates :name, presence: true
  validates :net_price_pennies, numericality: { greater_than: 0 }
end
