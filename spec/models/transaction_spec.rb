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

		before {
      transaction.booking = FactoryGirl.create :booking
      transaction.booking.payment_check_succeed
    }
		it 'should mark the booking as finish' do
			subject.should be_true
			transaction.booking.state.should be_eql("finished")
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
			subject.should eq("unfinished")
		end
	end

	describe '#complete_payment' do
		subject { transaction.complete_payment }

		let(:user) { FactoryGirl.create :user }
		let(:booking) { FactoryGirl.create :booking, booker: user }
		let(:transaction) { FactoryGirl.create :transaction, booking: booking }
		let(:response) { "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><SecurePayMessage><MessageInfo>
<messageID>8af793f9af34bea0cf40f5fb5c630c</messageID><messageTimestamp>20133012112658958000+660</messageTimestamp>
<apiVersion>spxml-4.2</apiVersion></MessageInfo><RequestType>Periodic</RequestType><MerchantInfo><merchantID>EHY0047
</merchantID></MerchantInfo><Status><statusCode>0</statusCode><statusDescription>Normal</statusDescription></Status>
<Periodic><PeriodicList count=\"1\"><PeriodicItem ID=\"1\"><actionType>trigger</actionType><clientID>1</clientID>
<responseCode>00</responseCode><responseText>Approved</responseText><successful>yes</successful><txnType>3</txnType>
<amount>2900</amount><currency>AUD</currency><txnID>346576</txnID><receipt>523166</receipt><ponum>5231661</ponum>
<settlementDate>20131230</settlementDate><CreditCardInfo><pan>444433...111</pan><expiryDate>01/13</expiryDate>
<recurringFlag>no</recurringFlag><cardType>6</cardType><cardDescription>Visa</cardDescription></CreditCardInfo>
</PeriodicItem></PeriodicList></Periodic></SecurePayMessage>" }

		context 'when stored card is used' do
			let(:card) { FactoryGirl.create :card, user: user, transaction: transaction }

			before { transaction.status = TRANSACTION_HOST_CONFIRMATION_REQUIRED }
			before { RestClient.stub(:post) { response } }

			it 'should complete the payment transaction' do
				subject.should be_true
			end
		end

		context 'when credit card is used' do
			before { transaction.status = TRANSACTION_PRE_AUTHORIZATION_REQUIRED }
			before { RestClient.stub(:post) { response } }

			it 'should complete the payment transaction' do
				subject.should be_true
			end
		end
	end

	describe '#client_id' do
		subject { transaction.client_id }

		let(:user) { FactoryGirl.create :user }
		let(:booking) { FactoryGirl.create :booking, booker: user }
		let(:transaction) { FactoryGirl.create :transaction, booking: booking }

		context 'when credit card transaction' do
			it 'should return booker id' do
				subject.should be_eql(user.id)
			end
		end

		context 'when stored card is used' do
			let(:card) { FactoryGirl.create :card, transaction: transaction, user: user }

			before { user.cards << card }

			it 'should return card token' do
				subject.should be_eql(card.token)
			end
		end
	end

	describe '#transaction_amount' do
		subject { transaction.transaction_amount }

		let(:transaction) { FactoryGirl.create :transaction }

		it 'should return transaction amount' do
			subject.should be_eql((transaction.amount * 100).to_i)
		end

		it 'should return valid transaction amount in cents for all valid amounts' do
			((1..999).inject(true) do |boolean, dollar|
				boolean && (0..99).inject(true) do |bool, cent|
					transaction.amount = dollar + (BigDecimal.new(cent.to_s) * BigDecimal.new('0.01'))
					result_amount =  transaction.transaction_amount
					bool && result_amount.to_s.include?(dollar.to_s) && result_amount.to_s.include?(cent.to_s)
				end
			end).should be_true
		end
	end
end
