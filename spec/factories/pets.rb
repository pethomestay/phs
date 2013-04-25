FactoryGirl.define do

  factory :pet do
    name { Faker::Name.first_name }
    date_of_birth { DateTime.now - 5.years }
    emergency_contact_name { Faker::Name.first_name }
    emergency_contact_phone '1234'
    pet_type_id 1
    size_id 2
    sex_id 2
  end
end
