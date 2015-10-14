FactoryGirl.define do
  factory :booking do
    cost_per_night 100.0
    check_in_date DateTime.current
    check_out_date DateTime.current
  end
end
