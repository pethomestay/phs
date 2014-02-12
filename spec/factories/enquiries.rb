FactoryGirl.define do

  factory :enquiry do
	  user { FactoryGirl.create(:user_with_pet) }
    homestay
    duration_id 1
	  check_in_date Time.zone.now
	  check_out_date Time.zone.now
  end
end
