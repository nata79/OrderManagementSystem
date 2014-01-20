# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    application
    token "token123"
    resource_owner_id { create :user }
  end
end
