module OrdersHelper
  def add_line_items order, options = {}
    count = options[:count] || 5
    product_price = options[:product_price] || 100

    count.times do
      product = create :product, net_price: Money.new(product_price, :gbp)
      create :line_item, order: order, product: product
    end
  end
end