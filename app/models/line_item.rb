class LineItem < ActiveRecord::Base
  monetize :net_price_pennies, as: 'net_price'

  belongs_to :product
  belongs_to :order

  validates :product, :order, :quantity, :net_price, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  before_validation :copy_net_price_from_product, if: :product_id_changed?

private
  def copy_net_price_from_product
    self.net_price = self.product.net_price unless self.product.nil?
  end
end
