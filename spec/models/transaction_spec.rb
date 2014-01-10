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
				subject.should be_eql('00.00')
			end
		end

		context 'when transaction has amount' do
			before { transaction.amount = 20 }
			it 'should return actual amount' do
				subject.should be_eql('20.00')
			end
		end
	end

	describe '#update_by_response' do
		subject {transaction}
		let(:transaction) { FactoryGirl.create :transaction }

		context 'when successful response from secure pay' do
			#before {@response = {time_stamp: Time.now.gmtime.strftime('%Y%m%d%H%M%S'), summary_code: '00', reference_id:
			#	"transaction_id=#{transaction.id}", fingerprint: }}
			it 'should return transaction with no error' do
				pending
			end
		end

		context 'when failure response from secure pay' do
			it 'should return transaction with errors' do
				pending
			end
		end

		context 'when successful response with card storage success' do
			it 'should return transaction with no errors and with stored card' do
				pending
			end
		end

		context 'when successful response with card storage failure' do
			it 'should return transaction with no errors but no card is saved' do
				pending
			end
		end
	end
end
