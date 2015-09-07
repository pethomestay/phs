FactoryGirl.define do
  factory :feedback do
    rating (1..5).to_a.sample
  end
end
