FactoryGirl.define do

  factory :user do
    first_name  { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 'abcdefghij'
    password_confirmation 'abcdefghij'
    date_of_birth { DateTime.now - 20.years }
    address_1 { Faker::Address.street_address }
    address_suburb 'Parnell'
    address_city 'Aukland'
    address_country 'NZ'
    mobile_number '04 5555 5555'
    accept_house_rules '1'
    accept_terms '1'
  end

  factory :confirmed_user, :parent => :user do
    after(:create) { |user| user.confirm! }
  end

  factory :user_with_pet, :parent => :confirmed_user do |f|
	  f.pets { [FactoryGirl.create(:pet)] }
  end
end
