FactoryGirl.define do

	factory :message do
		user
		mailbox
		message_text 'sample message'
	end
end
