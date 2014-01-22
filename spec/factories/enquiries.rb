FactoryGirl.define do

  factory :enquiry do
    user
    homestay
    duration_id 1
	  check_in_date Time.zone.now
	  check_out_date Time.zone.now
  end
end
