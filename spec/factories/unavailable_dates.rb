FactoryGirl.define do

  factory :unavailable_date do
    date Date.today.end_of_month
    association :user, factory: :confirmed_user
  end

end

