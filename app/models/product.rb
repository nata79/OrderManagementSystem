class Product < ActiveRecord::Base
  monetize :net_price_pennies, as: 'net_price'

  has_many :line_items

  validates :name, presence: true, uniqueness: true
  validates :net_price_pennies, numericality: { greater_than: 0 }

  before_destroy :check_for_line_items

private
  def check_for_line_items
    self.line_items.empty?
  end
end
