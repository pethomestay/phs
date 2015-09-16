FactoryGirl.define do
  factory :mailbox do
    enquiry_id 1
    booking_id 1

    trait :past do
      created_at Date.today - 1.day
    end
  end
end
