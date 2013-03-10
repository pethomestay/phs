require 'machinist/active_record'

Enquiry.blueprint do
  user
  homestay
  duration_id { 1 }
end

Homestay.blueprint do
  cost_per_night { 0 }
  address_1 { Faker::Address.street_address }
  address_suburb {'Collingwood'  }
  address_city { 'Melbourne'  }
  address_country { 'AU' }
  title { Faker::Company.name }
  description { Faker::Lorem.paragraph }
  property_type_id { 1 }
  outdoor_area_id { 2 }
  slug { "slug-title-#{sn}" }
  user

  accept_liability { '1' }
  parental_consent { '1' }
end

Pet.blueprint do
  name { Faker::Name.first_name }
  date_of_birth { DateTime.now - 5.years }
  emergency_contact_name { Faker::Name.first_name }
  emergency_contact_phone { '1234' }
  pet_type_id { 1 }
  size_id { 2 }
  sex_id { 2 }
end

User.blueprint do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  email { Faker::Internet.email }
  password { 'abcdefghij' }
  date_of_birth { DateTime.now - 20.years }
  address_1 { Faker::Address.street_address }
  address_suburb { 'Parnell' }
  address_city { 'Aukland' }
  address_country { 'NZ' }
  accept_house_rules { '1' }
  accept_terms { '1' }
end
