FactoryGirl.define do
  factory :enquiry do
    message 'hello'
    check_in_time DateTime.now - 1.day
    check_out_time DateTime.now
    check_in_date DateTime.now - 1.day
    check_out_date DateTime.now
    duration_id 1
  end
end
