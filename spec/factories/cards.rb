FactoryGirl.define do
  factory :card do
    sequence(:card_number) { |n| "card_number_#{n}" }
    token "12345"
  end
end
