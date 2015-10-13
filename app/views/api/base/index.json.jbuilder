json.data do
  json.pet do
    json.breeds DOG_BREEDS.sort
    json.energy_levels(ReferenceData::EnergyLevel.all) do |energy_level|
      json.id energy_level.id.try(:to_i)
      json.description energy_level.title
    end
    json.personalities PERSONALITIES.sort
    json.sexes(ReferenceData::Sex.all) do |sex|
      json.id sex.id.try(:to_i)
      json.description sex.title
    end
    json.sizes(ReferenceData::Size.all) do |size|
      json.id size.id.try(:to_i)
      json.description size.title
    end
    json.types(ReferenceData::PetType.all) do |pet_type|
      json.id pet_type.id.try(:to_i)
      json.description pet_type.title
    end
  end
end
