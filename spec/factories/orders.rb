# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    status "MyString"
    order_date "2013-07-13"
    vat ""
  end
end
