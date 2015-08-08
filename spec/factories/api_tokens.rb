FactoryGirl.define do
  factory :api_token do
    sequence(:name) {|n| "Token ##{n}"}
    active true
  end
end
