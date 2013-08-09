FactoryGirl.define do

  factory :user do
    first_name  { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 'abcdefghij'
    date_of_birth { DateTime.now - 20.years }
    address_1 { Faker::Address.street_address }
    address_suburb 'Parnell'
    address_city 'Aukland'
    address_country 'NZ'
    accept_house_rules '1'
    accept_terms '1'
  end
end