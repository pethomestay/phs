FactoryGirl.define do
  factory :homestay do
    user
    sequence(:title) { |n| "MyString#{n}" }
    sequence(:slug)  { |n| "MyString#{n}" }

    address_1       "MyString"
    address_suburb  "MyString"
    address_city    "MyString"
    address_country "MyString"
    description     "MyString"
    visits_price    1
    visits_radius   1
    delivery_price  1
    delivery_radius 1
  end
end
