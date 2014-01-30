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
		let(:transaction) { FactoryGirl.create :transaction, booking: FactoryGirl.create(:booking) }
		context 'when transaction has no amount' do
			it 'should return nil' do
				subject.should be_eql('1.00')
			end
		end

		context 'when transaction has amount' do
			before { transaction.booking.amount = 20 }
			it 'should return actual amount' do
				subject.should be_eql('20.00')
			end
		end
	end

	describe '#update_by_response' do
		subject { transaction }
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

	describe '#finish_booking' do
		subject { transaction.finish_booking }
		let(:transaction) { FactoryGirl.create :transaction }

		before { transaction.booking = FactoryGirl.create :booking }
		it 'should mark the booking as finish' do
			subject.should be_true
			transaction.booking.status.should be_eql(BOOKING_STATUS_FINISHED)
		end

		context 'when booking has enquiry' do
			before { transaction.booking.enquiry = FactoryGirl.create :enquiry }
			it 'should finish booking and update enquiry' do
				subject.should be_true
				transaction.booking.enquiry.confirmed.should be_true
			end
		end
	end

	describe '#update_status' do
		subject { transaction.update_status }
		let(:transaction) { FactoryGirl.create :transaction }

		before { transaction.booking = FactoryGirl.create :booking }
		it 'should update the transaction' do
			subject.should be_true
			transaction.status.should eql(TRANSACTION_HOST_CONFIRMATION_REQUIRED)
		end

		context 'when transaction have stored card' do
			subject { transaction }
			let(:card) { FactoryGirl.create :card }

			it 'should update the transaction with card' do
				subject.update_status(card.id).should be_true
			end
		end
	end

	describe '#error_messages' do
		subject { transaction.error_messages }
		let(:transaction) { FactoryGirl.create :transaction }

		context 'when there is no error message' do
			it 'should return nil' do
				subject.should be_blank
			end
		end

		context 'when there are errors' do
			before { transaction.errors.add(:response_text, 'Credit Card is not Valid') }
			it 'should return string containing error message' do
				subject.should include('Credit Card is not Valid')
			end
		end
	end

	describe '#confirmed_by_host' do
		subject { transaction.confirmed_by_host }
		let(:transaction) { FactoryGirl.create :transaction }

		before { transaction.booking = FactoryGirl.create :booking }
		it 'should confirm the host booking' do
			subject
			transaction.booking.host_accepted?.should be_true
		end
	end

	describe '#booking_status' do
		subject { transaction.booking_status }
		let(:transaction) { FactoryGirl.create :transaction }

		before { transaction.booking = FactoryGirl.create :booking }
		it 'should return the booking status' do
			subject.should eq(BOOKING_STATUS_UNFINISHED)
		end
	end
end
