FactoryGirl.define do
  factory :booking do
    subtotal 10.0
    check_in_date DateTime.now
    check_out_date DateTime.now
  end
end
