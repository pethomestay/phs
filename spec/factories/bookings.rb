FactoryGirl.define do

	factory :booking do
		booker { FactoryGirl.create :user }
		bookee { FactoryGirl.create :user }
	end
end
