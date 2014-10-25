require 'spec_helper'

describe Card, :type => :model do
	it { is_expected.to belong_to :user }
	it { is_expected.to have_one :transaction }

	it 'should be valid with valid attributes' do
		card = FactoryGirl.create :card
		expect(card).to be_valid
	end
end
