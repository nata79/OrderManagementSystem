class LineItem < ActiveRecord::Base
  monetize :net_price_pennies, as: 'net_price'

  belongs_to :product
  belongs_to :order

  validates :product, :order, :quantity, :net_price, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  validate :order_is_not_locked

  before_validation :copy_net_price_from_product, if: :product_id_changed?

private
  def copy_net_price_from_product
    self.net_price = self.product.net_price unless self.product.nil?
  end

  def order_is_not_locked
    errors.add :order, 'cannot be updated with this status' if self.order and self.order.locked?
  end
end
