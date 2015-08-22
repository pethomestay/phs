json.id homestay.id
json.slug homestay.slug
json.title homestay.title
json.description homestay.description
json.score -1
json.distance -1
json.image do
  json.partial! 'image', image: homestay.photos.first
end
json.host do
  json.partial! 'user', user: homestay.user
  json.average_rating homestay.average_rating
  json.responsiveness_rate homestay.user.response_rate_in_percent
  json.last_login_at homestay.user.current_sign_in_at.to_i
end
json.profile do
  json.favourite_breeds homestay.favorite_breeds
  json.accepted_sizes extract_pet_sizes(homestay)
  json.accespted_energy_levels extract_energy_levels(homestay)
  json.emergency_transport homestay.emergency_transport?
  json.police_check homestay.police_check?
  json.constant_supervision homestay.constant_supervision?
end
json.location do
  json.address do
    json.street extract_street_address(homestay)
    json.suburb extract_suburb(homestay)
    json.state extract_state(homestay)
    json.postcode homestay.address_postcode
  end
  json.position do
    json.latitide homestay.latitude
    json.longitude homestay.longitude
  end
end
json.images(homestay.photos) do |image|
  json.partial! 'image', image: image
end
json.prices(['local', 'remote', 'walking', 'grooming', 'delivery']) do |service|
  json.service service
  json.price service_cost(homestay, service)
end
json.reviews(homestay.user.received_feedbacks) do |review|
  json.id review.id
  json.user do
    json.partial! 'user', user: review.user
  end
  json.rating review.rating
  json.review review.review
  json.created_at review.created_at.to_i
end
