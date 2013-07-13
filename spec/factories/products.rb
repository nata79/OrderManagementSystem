# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:name) { |n| "Product - #{n}" }
    net_price Money.new(100)
  end
end
