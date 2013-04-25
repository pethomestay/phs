FactoryGirl.define do

  factory :homestay do
    cost_per_night 0
    address_1 { Faker::Address.street_address }
    address_suburb 'Collingwood'
    address_city 'Melbourne'
    address_country 'AU'
    title { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    property_type_id 1
    outdoor_area_id 2
    sequence(:slug) {|sn| "slug-title-#{sn}" }
    user

    accept_liability '1'
    parental_consent '1'
  end
end
