FactoryGirl.define do

  factory :enquiry do
    user { FactoryGirl.create(:user_with_pet) }
    homestay
    duration_id 1
    check_in_date Date.today
    check_in_time Time.zone.now
    check_out_time Time.zone.now + 1.day
    check_out_date Date.today + 1.day
  end
end
