require 'spec_helper'

describe Transaction do
	it { should belong_to :booking }
	it { should belong_to :card }

	it 'should be valid with valid attributes' do
		transaction = FactoryGirl.create :transaction
		transaction.should be_valid
	end

	describe '#actual_amount' do
		subject { transaction.actual_amount }
		let(:transaction) { FactoryGirl.create :transaction }
		context 'when transaction has no amount' do
			it 'should return nil' do
				subject.should be_nil
			end
		end

		context 'when transaction has amount' do
			before { transaction.amount = 20 }
			it 'should return actual amount' do
				subject.should be_eql('20.00')
			end
		end
	end
end
