json.pets do
  json.array! @pets.each do |pet|
    json.partial! 'pet', pet: pet
  end
end
