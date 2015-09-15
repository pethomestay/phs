FactoryGirl.define do
  factory :user do
    first_name 'Tom'
    last_name 'LeGrice'
    sequence(:email) {|n| "tom_#{n}@pethomestay.com"}
    password 'password'
    active true
    mobile_number '123456789'

    trait :with_address do
      sequence(:address_1) {|n| "Unit #{n}"}
      address_suburb 'Suburb'
      address_city 'Melbourne'
      address_country 'Australia'
    end
  end
end
