FactoryGirl.define do
  factory :pet do
    sequence(:name) { |n| "Pet ##{n}" }
    pet_type_id 1
    pet_age 1
    size_id ReferenceData::Size.find((0..3).to_a.sample).id
    sex_id ReferenceData::Sex.find((0..3).to_a.sample).id
    energy_level 1
  end
end
