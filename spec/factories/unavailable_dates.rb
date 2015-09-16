FactoryGirl.define do
  factory :unavailable_date do
    date DateTime.current
  end
end
