# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    product nil
    order nil
    net_price ""
    quantity ""
  end
end
