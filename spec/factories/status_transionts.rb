# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status_transition do
    order
    event :place
  end
end
