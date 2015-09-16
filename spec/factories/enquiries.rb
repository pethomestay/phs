FactoryGirl.define do
  factory :enquiry do
    message 'hello'
    check_in_time DateTime.current - 1.day
    check_out_time DateTime.current
    check_in_date DateTime.current - 1.day
    check_out_date DateTime.current
    duration_id 1
  end
end
