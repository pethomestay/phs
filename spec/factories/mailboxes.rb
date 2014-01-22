FactoryGirl.define do

	factory :mailbox do
		guest_mailbox { FactoryGirl.create :user }
		host_mailbox { FactoryGirl.create :user }
		enquiry
	end
end
