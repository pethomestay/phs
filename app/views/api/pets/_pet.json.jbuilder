json.id pet.id
json.name pet.name
json.type pet.pet_type_id
json.breed pet.breed
json.age pet.pet_age
json.sex pet.sex_id
json.size pet.size_id
json.energy_level pet.energy_level
json.personality pet.personalities
json.image do
  json.partial! 'api/images/image', image: pet.profile_photo
end
