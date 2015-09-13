FactoryGirl.define do
  factory :homestay do
    user

    address_1       "MyString"
    address_suburb  "MyString"
    address_city    "MyString"
    address_country "MyString"
    title           "MyString"
    description     "MyString"
    visits_price    1
    visits_radius   1
    delivery_price  1
    delivery_radius 1
  end
end
