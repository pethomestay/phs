FactoryGirl.define do

	factory :booking do
		booker { FactoryGirl.create :user }
		bookee { FactoryGirl.create :user }
    transaction { FactoryGirl.create :transaction}
    check_in_date Date.today
    check_out_date (Date.today + 2.days)
	end

  factory :booked_booking, :parent => :booking do
    owner_accepted true
    host_accepted  true
  end
end
