FactoryGirl.define do
  factory :coupon do
    sequence(:code) { |n| "ABC#{n}" }
    discount_amount 10
  end
end
