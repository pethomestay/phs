require 'spec_helper'

describe Card do
	it { should belong_to :user }
	it { should have_one :transaction }

	it 'should be valid with valid attributes' do
		card = FactoryGirl.create :card
		card.should be_valid
	end
end
