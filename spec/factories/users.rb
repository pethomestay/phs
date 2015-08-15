FactoryGirl.define do
  factory :user do
    first_name 'Tom'
    last_name 'LeGrice'
    sequence(:email) {|n| "tom_#{n}@pethomestay.com"}
    password 'password'
  end
end
