require 'spec_helper'

describe Account, :type => :model do
	it { is_expected.to belong_to :user }

	it { is_expected.to validate_presence_of :account_number }
	it { is_expected.to validate_presence_of :bank }
	it { is_expected.to validate_presence_of :bsb }
	it { is_expected.to validate_presence_of :name }

	it { is_expected.to ensure_length_of(:account_number).is_at_least(7) }
	it { is_expected.to ensure_length_of(:account_number).is_at_most(20) }
	it { is_expected.to ensure_inclusion_of(:account_number).matches?(:integer) }

	describe '#hidden_account_number' do
		subject { account.hidden_account_number }
		let(:account) { FactoryGirl.create :account }

		it 'should return account number hidden by *' do
			expect(subject).to be_eql('***4567')
		end
	end
end