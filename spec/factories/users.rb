FactoryGirl.define do
  factory :user do
    first_name 'Tom'
    last_name 'LeGrice'
    sequence(:email) {|n| "tom_#{n}@pethomestay.com"}
    password 'password'
    active true
    mobile_number "0927000000"
  end
end
