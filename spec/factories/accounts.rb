FactoryGirl.define do

	factory :account do
		user { FactoryGirl.create :user }
		account_number '1234567'
		bsb 'bank bsb'
		bank 'SCB'
		name 'Bilal Basharat'
	end
end
