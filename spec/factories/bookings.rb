FactoryGirl.define do

	factory :booking do
		booker { FactoryGirl.create :user }
		bookee { FactoryGirl.create :user }
    transaction { FactoryGirl.create :transaction}
		check_in_date Time.now
		check_out_date Time.now
	end
end
