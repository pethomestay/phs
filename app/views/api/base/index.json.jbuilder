json.data do
  json.pet do
    json.breeds DOG_BREEDS.sort
    json.energy_levels(ReferenceData::EnergyLevel.all) do |energy_level|
      json.id energy_level.id
      json.description energy_level.title
    end
    json.personalities PERSONALITIES.sort
    json.sexes(ReferenceData::Sex.all) do |sex|
      json.id sex.id
      json.description sex.title
    end
    json.sizes(ReferenceData::Size.all) do |size|
      json.id size.id
      json.description size.title
    end
    json.types(ReferenceData::PetType.all) do |pet_type|
      json.id pet_type.id
      json.description pet_type.title
    end
  end
end
