object @order
attributes :id, :order_date, :vat, :status

node(:net_total_pennies) { |order| order.net_total.cents }
node(:net_total_currency) { |order| order.net_total.currency.iso_code }

node(:gross_total_pennies) { |order| order.gross_total.cents }
node(:gross_total_currency) { |order| order.gross_total.currency.iso_code }

child :line_items do
  extends "api/v1/line_items/show"
end

node(:location) { |order| api_v1_order_url(order) }