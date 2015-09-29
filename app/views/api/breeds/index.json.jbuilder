json.breeds do
  json.array! @breeds.each do |breed|
    json.type 'dog'
    json.name breed
  end
end
