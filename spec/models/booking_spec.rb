require 'spec_helper'
require 'pry'

describe Booking do
	it { should belong_to :booker }
	it { should belong_to :bookee }
	it { should belong_to :enquiry }
	it { should belong_to :homestay }
	it { should have_one :transaction }

	it { should validate_presence_of :booker_id }
	it { should validate_presence_of :bookee_id }
	it { should validate_presence_of :check_in_date }
	it { should validate_presence_of :check_out_date }

	it 'should be valid with valid attributes' do
		booking = FactoryGirl.create :booking
		booking.should be_valid
	end

	describe '#destroy_dependents' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking, enquiry: FactoryGirl.create(:enquiry) }

		before do
			subject.transaction = FactoryGirl.create :transaction
			subject.save!
		end

		it 'should have transacton' do
			subject.transaction.persisted?.should be_true
		end

		it 'should have enquiry' do
			subject.enquiry.persisted?.should be_true
		end

		it 'should have mailbox' do
			subject.mailbox.persisted?.should be_true
		end

		context 'when subject is destroyed' do
			before do
				subject.destroy
			end
			it 'should destroy it transaction' do
				Transaction.all.should be_blank
			end

			it 'should destroy its mailboxes' do
				Mailbox.all.should be_blank
			end
		end
  end

  # def actual_status
  #   if self.status == BOOKING_STATUS_UNFINISHED
  #     BOOKING_STATUS_UNFINISHED
  #   elsif self.status == BOOKING_STATUS_FINISHED && !self.host_accepted?
  #     'awaiting host response'
  #   elsif self.status == BOOKING_STATUS_FINISHED && self.host_accepted?
  #     'host accepted but not paid'
  #   elsif self.status == BOOKING_STATUS_REJECTED
  #     'host rejected'
  #   elsif self.status == BOOKING_STATUS_HOST_PAID
  #     'host has been paid'
  #   else
  #     'invalid booking state'
  #   end
  # end


  describe '#human_state_name' do #was actual_status
    subject { booking }
    let(:booking) { FactoryGirl.create :booking }

    context 'when a booking is finished' do
      before {
        booking.payment_check_succeed
      }

      it 'should return awaiting host response' do
        Booking.human_state_name(subject.state.to_sym).should be_eql("awaiting host response")
      end
    end

    context 'when a booking is unfinished' do
      it 'should return "unfinished"' do
        Booking.human_state_name(subject.state.to_sym).should be_eql("unfinished")
      end
    end

    context 'when a booking is finished and the host has accepted' do
      before {
        booking.payment_check_succeed
        booking.host_accepts_booking
      }
      it 'should return "host accepted but not paid"' do
        Booking.human_state_name(subject.state.to_sym).should be_eql("host accepted but not paid")
      end
    end

    context 'when a booking is rejected' do
      before {
        booking.payment_check_succeed
        booking.host_rejects_booking
        booking.update_attributes owner_accepted: true, host_accepted: false
      }
      it 'should return "host rejected"' do
        Booking.human_state_name(subject.state.to_sym).should be_eql("host rejected")
      end
    end

    context 'when a booking has been paid' do
      before {
        booking.update_attributes owner_accepted: true, host_accepted: true, state: :host_paid
      }
      it 'should return "host has been paid"' do
        Booking.human_state_name(subject.state.to_sym).should be_eql("host has been paid")
      end
    end

  end


	describe '#message_update' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking }
		before { @new_message = 'new message' }

		context 'when booking has no message' do
			before { subject.message_update(@new_message) }

			it 'should update the booking message' do
				subject.message.should be_eql(@new_message)
			end

			it 'should create message in mailbox' do
				subject.mailbox.messages.first.message_text.should be_eql(@new_message)
			end
		end

		context 'when booking already has a message' do
			before do
				@old_message = 'old message'
				subject.message_update(@old_message)
				subject.message_update(@new_message)
			end

			it 'should update the message' do
				subject.message.should be_eql(@new_message)
			end

			it 'should update the mailbox' do
				subject.mailbox.messages.first.message_text.should be_eql(@new_message)
			end
		end
	end

	describe '#bookee and #booker' do
		before :each do
			@booking = FactoryGirl.create :booking
		end

		it 'should have booker i.e. guest' do
			@booking.booker.id.should_not be_blank
		end

		it 'should have bookee i.e. host' do
			@booking.bookee.id.should_not be_blank
		end
	end

	describe '#unfinished' do
		subject { Booking.unfinished }
		context 'when there is no unfinished booking' do
			it 'should return []' do
				subject.should be_blank
			end
		end

		context 'when there is an unfinished booking' do
			before { FactoryGirl.create :booking }
			it 'should return unfinished booking' do
				subject.size.should be_eql(1)
			end
		end
	end

	describe '#needing_host_confirmation' do
		subject { Booking.needing_host_confirmation }
		context 'when no booking needed host confirmation' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				subject.should be_blank
			end
		end

		context 'when there is a booking needed host confirmation' do
			before { FactoryGirl.create :booking, owner_accepted: true, response_id: 0 }
			it 'should not return any booking' do
				subject.size.should be_eql(1)
			end
		end
	end

	describe '#declined_by_host' do
		subject { Booking.declined_by_host }
		context 'when no booking declined by host' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				subject.should be_blank
			end
		end

		context 'when there is a booking declined by host' do
			before { FactoryGirl.create :booking, response_id: ReferenceData::Response::UNAVAILABLE.id }
			it 'should not return any booking' do
				subject.size.should be_eql(1)
			end
		end
	end

	describe '#required_response' do
		subject { Booking.required_response }
		context 'when no host requires owner to answer his question' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				subject.any?.should be_false
			end
		end

		context 'when host wants owner to answer his question' do
			before { FactoryGirl.create :booking, response_id: ReferenceData::Response::QUESTION.id }
			it 'should return booking' do
				subject.any?.should be_true
			end
		end
	end

	describe '#accepted_by_host' do
		subject { Booking.accepted_by_host }
		context 'when no host accepts booking' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				subject.any?.should be_false
			end
		end

		context 'when host accepts booking' do
			before { FactoryGirl.create :booking, response_id: ReferenceData::Response::AVAILABLE.id, host_accepted: true }
			it 'should return booking' do
				subject.any?.should be_true
			end
		end
	end

	describe '#host_view?' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking }
		context 'when current user is booker i.e. guest' do
			it 'should return false' do
				subject.host_view?(subject.booker).should be_false
			end
		end

		context 'when current user is bookee i.e. host. And guest did not complete the booking.' do
			it 'should return false' do
				subject.host_view?(subject.bookee).should be_false
			end
		end

		context 'when current user is bookee and guest made booking for him' do
			before {
        booking.payment_check_succeed
        booking.update_attributes owner_accepted: true
      }
			it 'should return true' do
				subject.host_view?(subject.bookee).should be_true
			end
		end
	end

	describe '#owner_view?' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking }
		context 'when current user is bookee i.e. host' do
      before {
        booking.payment_check_succeed
      }
			it 'should return false' do
				subject.owner_view?(subject.bookee).should be_false
			end
		end

		context 'when current user is booker or owner or guest' do
			it 'should return true' do
				subject.owner_view?(subject.booker).should be_true
			end
		end
	end

	describe '#editable_datetime?' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking }

		context 'when booking is finished' do
			before do
				booking.owner_accepted = true
				booking.state = :finished
			end

			it 'should return false' do
				subject.editable_datetime?(subject.booker).should be_false
			end
		end

		context 'when booking is not finished and it has no enquiry and owner is logged in' do
			it 'should return true' do
				subject.editable_datetime?(subject.booker).should be_true
			end
		end
	end

	describe '#confirmed_by_host' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking }

		before :each do
			subject.stub(:complete_transaction).with(booking.bookee).and_return true
		end

		context 'when host confirmed the booking' do
			it 'should return success message' do
				PetOwnerMailer.stub(:booking_receipt).with(subject).and_return mock(:mail, deliver: true)
				booking.check_in_date = Time.now
				booking.check_out_date = Time.now
				booking.homestay = FactoryGirl.create :homestay
				pet = FactoryGirl.create :pet
				booking.booker.pets << pet
				subject.confirmed_by_host(booking.bookee).should be_eql('You have confirmed the booking')
			end
		end

		context 'when host confirmed unavailability' do
			before { booking.response_id = ReferenceData::Response::UNAVAILABLE.id }

			it 'should return message that guest will be known of your unavailability' do
				PetOwnerMailer.stub(:provider_not_available).with(subject).and_return mock(:mail, deliver: true)
				subject.confirmed_by_host(booking.bookee).should be_eql('Guest will be informed of your unavailability')
			end
		end

		context 'when host ask a question from guest' do
			before { booking.response_id = ReferenceData::Response::QUESTION.id }

			it 'should return message that guest will have your question' do
				PetOwnerMailer.stub(:provider_has_question).with(subject, nil).and_return mock(:mail, deliver: true)
				subject.confirmed_by_host(booking.bookee).should be_eql('Your question has been sent to guest')
			end
		end
	end

	describe '#remove_notification' do
		subject { booking.remove_notification }
		let(:booking) { FactoryGirl.create :booking }

		context 'when there is a notification' do
			before do
        booking.payment_check_succeed
        booking.update_attributes owner_accepted: true
				booking.homestay = FactoryGirl.create :homestay, user: booking.bookee
				booking.save
				booking.bookee.notifications?.should be_true
			end

			it 'should remove all notification' do
				subject.should be_true
				booking.bookee.notifications?.should be_false
			end
		end
	end

	describe '#update_transaction_by' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking }
		before { booking.transaction = FactoryGirl.create :transaction }

		context 'when required parameters are provided' do
			it 'should update transaction and will return response hash' do
				result = subject.update_transaction_by(1, Time.now, Time.now + 2.days)
				result.keys.should be_eql([:booking_subtotal, :booking_amount, :transaction_fee, :transaction_actual_amount,
				                           :transaction_time_stamp, :transaction_merchant_fingerprint])
			end
		end

		context 'when any of the required parameters is absent' do
			it 'should return error hash' do
				result = subject.update_transaction_by(nil, Time.now, Time.now + 2.days)
				result.keys.should be_eql([:error])
			end
		end
	end

	describe '#complete transaction' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking }

		context 'when its called in a host view' do
			context 'when booking is finished' do

				before {
          booking.payment_check_succeed
          booking.host_accepts_booking #state should be finished_host_accepted
          booking.update_attributes host_accepted: true, owner_accepted: true
        }
				it 'should complete the payment' do
					subject.transaction.stub(:complete_payment).and_return true
					subject.complete_transaction(subject.bookee).should be_true
				end
			end

			context 'when booking is not finished' do
				it 'should return nil' do
					subject.complete_transaction(subject.bookee).should be_nil
				end
			end
		end

		context 'when its called in an owner\'s view' do
			context 'when booking is finished' do
				before {
          booking.payment_check_succeed
          booking.host_accepts_booking #state should be finished_host_accepted
          booking.update_attributes host_accepted: true, owner_accepted: true }

				it 'should remove the notification' do
					subject.complete_transaction(subject.booker).should be_true
				end
			end

			context 'when booking is not finished' do
				it 'should return nil' do
					subject.complete_transaction(subject.booker).should be_nil
				end
			end
		end
	end

	describe 'transaction helper functions' do
		let(:booking) { FactoryGirl.create :booking }
		before do
			booking.number_of_nights = 2
			booking.cost_per_night = 30
			booking.subtotal = 60
			booking.amount = booking.subtotal + booking.transaction_fee.to_f
		end

		describe '#host_payout' do
			subject { booking.host_payout }

			it 'will deduct PetHomeStay service charge and public liability insurance and transaction fee' do
				booking.amount.should be_eql(61.08)
				booking.phs_service_charge.should be_eql('9.00')
				booking.public_liability_insurance.should be_eql('4.00')
				booking.transaction_fee.should be_eql('1.08')
				subject.should be_eql('47.00')
			end
		end

		describe '#host_booking_status' do
			subject { booking.host_booking_status }

			context 'when status is accepted' do
				before { booking.host_accepted = true }

				it 'should return "Accepted"' do
					subject.should be_eql('Booking $47.00 - Accepted')
				end
			end

			context 'when status is pending' do
				before { booking.host_accepted = false }

				it 'should return "Pending"' do
					subject.should be_eql('Booking $47.00 - Pending')
				end
			end

			context 'when status is rejected' do
				before {
          booking.payment_check_succeed
          booking.update_attributes host_accepted: false, owner_accepted: true
					booking.host_rejects_booking
					booking.host_accepted = false
				}

				it 'should return "Rejected"' do
					subject.should be_eql('Booking $47.00 - Rejected')
				end
			end
		end

		describe '#guest_booking_status ' do
			subject { booking.guest_booking_status }

			context 'when status is accepted' do
				before { booking.host_accepted = true }

				it 'should return "Accepted"' do
					subject.should be_eql('Booking $61.08 - Accepted')
				end
			end

			context 'when status is pending' do
				before { booking.host_accepted = false }

				it 'should return "Pending"' do
					subject.should be_eql('Booking $61.08 - Pending')
				end
			end

			context 'when status is rejected' do
				before {
          booking.payment_check_succeed
					booking.host_rejects_booking
					booking.host_accepted = false
				}

				it 'should return "Rejected"' do
					subject.should be_eql('Booking $61.08 - Rejected')
				end
			end
		end

		describe '#fees' do
			subject { booking.fees }

			it 'should return transaction fees paid by guest' do
				subject.should be_eql('1.08')
			end
		end

		describe '#actual_amount' do
			subject { booking.actual_amount }

			it 'will return the transaction amount in string format' do
				subject.should be_eql('61.08')
			end
		end

		describe '#transaction_fee' do
			subject { booking.transaction_fee }

			context 'live mode' do
				before { booking.stub(:live_mode_rounded_value?).and_return(true) }

				it 'will return transaction value rounded 2 digit with actual cents value' do
					subject.should be_eql('1.50')
				end
			end

			context 'test mode' do
				before { booking.stub(:live_mode_rounded_value?).and_return(false) }

				it 'will return transaction value rounded 2 digit with actual cents value' do
					subject.should be_eql(1.08.to_s)
				end
			end
		end

	end
end