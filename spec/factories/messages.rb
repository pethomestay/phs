FactoryGirl.define do
  factory :message do
    message_text 'sample message'

    trait :past do
      created_at Date.today - 1.day
    end
  end
end
