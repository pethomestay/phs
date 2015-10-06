FactoryGirl.define do
  factory :device do
    sequence(:token) {|n| "token-#{n}"}
    active true
  end
end
