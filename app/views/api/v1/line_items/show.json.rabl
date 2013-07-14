object @line_item
attributes :id, :quantity, :net_price_pennies, :net_price_currency

child :product do
  attributes :id, :name
  
  node(:location) { |product| api_v1_product_url(product) }
end

node(:location) { |line_item| api_v1_order_line_item_url(line_item.order, line_item) }