FactoryGirl.define do

  factory :unavailable_date do
    date Date.today.end_of_month
  end

end

