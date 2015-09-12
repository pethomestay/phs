FactoryGirl.define do
  factory :pet do
    sequence(:name) {|n| "Pet ##{n}"}
    pet_type_id 1
    size_id 1
    pet_age 1
    sex_id 1
    energy_level 1
  end
end
