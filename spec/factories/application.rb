# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :application, class: Doorkeeper::Application do
    sequence(:name) { |i| "App#{i}" }
    sequence(:uid) { |i| "AppUid#{i}" }
    secret "123123123"
    redirect_uri "http://fake.com"
  end
end
