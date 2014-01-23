require 'spec_helper'

describe Account do
	it { should belong_to :user }

	it { should validate_presence_of :account_number }
	it { should validate_presence_of :bank }
	it { should validate_presence_of :bsb }
	it { should validate_presence_of :name }

	it { should ensure_length_of(:account_number).is_at_least(7) }
	it { should ensure_length_of(:account_number).is_at_most(20) }
	it { should ensure_inclusion_of(:account_number).matches?(:integer) }

	describe '#hidden_account_number' do
		subject { account.hidden_account_number }
		let(:account) { FactoryGirl.create :account }

		before { account.account_number = '1234567' }

		it 'should return account number hidden by *' do
			subject.should be_eql('***4567')
		end
	end
end