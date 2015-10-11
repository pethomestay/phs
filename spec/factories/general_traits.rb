FactoryGirl.define do
  trait :without_validation do
    to_create {|instance| instance.save(validate: false) }
  end
end
