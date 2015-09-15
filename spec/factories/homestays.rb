FactoryGirl.define do
  factory :homestay do
    sequence(:title) { |n| 'homestay#{n}'}
    address_city 'Melbourne'
    description 'A very cool place'
    cost_per_night 10
  end
end
