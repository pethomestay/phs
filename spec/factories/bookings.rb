FactoryGirl.define do
  factory :booking do
    cost_per_night 100.0
    check_in_date DateTime.now
    check_out_date DateTime.now
  end
end
