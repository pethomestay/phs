FactoryGirl.define do

	factory :account do
		user { FactoryGirl.create :user }
		account_number '1234567'
		bsb '1233456'
		name 'Bilal Basharat'
	end
end
