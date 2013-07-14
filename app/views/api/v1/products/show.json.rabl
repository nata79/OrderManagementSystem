object @product
attributes :id, :name, :net_price_pennies, :net_price_currency

node(:location) { |product| api_v1_product_url(product) }