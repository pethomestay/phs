

describe Booking, :type => :model do

  before do
    allow_any_instance_of(Homestay).to receive(:geocoding_address).and_return("Melbourne, MB")
  end

	it { is_expected.to belong_to :booker }
	it { is_expected.to belong_to :bookee }
	it { is_expected.to belong_to :enquiry }
	it { is_expected.to belong_to :homestay }
	it { is_expected.to have_one :transaction }

	it { is_expected.to validate_presence_of :booker_id }
	it { is_expected.to validate_presence_of :bookee_id }
	it { is_expected.to validate_presence_of :check_in_date }
	it { is_expected.to validate_presence_of :check_out_date }

  it 'should be valid with valid attributes' do
		booking = FactoryGirl.create :booking
		expect(booking).to be_valid
	end

  #describe "host's availability validation" do

    #let(:start_date){ Date.today - 2.days }
    #let(:end_date){ Date.today + 4.days }
    #let(:booking){ FactoryGirl.create(:booking, check_in_date: start_date, check_out_date: end_date) }

    #context "when host is unavailable between check in and check out date" do
      #it "should generate a validation error" do
        #unav_date = FactoryGirl.create(:unavailable_date, user: booking.bookee, date: Date.today)
        #expect(booking.valid?).to eq(false)
        #expect(booking.errors.full_messages).to eq(["Host is either unavailable or booked on #{ unav_date.date }"])
      #end
    #end

    #context "when host is booked between check in and check out date" do
      #it "should generate a validation error" do
        #prev_booking = FactoryGirl.create(:booking, bookee: booking.bookee, check_in_date: start_date + 1, check_out_date: start_date + 1, state: :finished_host_accepted)
        #expect(booking.valid?).to eq(false)
        #expect(booking.errors.full_messages).to eq(["Host is either unavailable or booked on #{ (prev_booking.check_in_date..prev_booking.check_out_date).to_a.join(', ') }"])
      #end
    #end

  #end

  it "should validate that check in date is not greater than checkout date" do
    booking = FactoryGirl.build(:booking, check_in_date: Date.today, check_out_date: Date.today - 1.day)
    expect(booking.valid?).to eq(false)
  end

	describe '#destroy_dependents' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking, enquiry: FactoryGirl.create(:enquiry) }

		before do
			subject.transaction = FactoryGirl.create :transaction
			subject.save!
		end

		it 'should have transacton' do
			expect(subject.transaction.persisted?).to be_truthy
		end

		it 'should have enquiry' do
			expect(subject.enquiry.persisted?).to be_truthy
		end

		it 'should have mailbox' do
			expect(subject.mailbox.persisted?).to be_truthy
		end

		context 'when subject is destroyed' do
			before do
				subject.destroy
			end
			it 'should destroy it transaction' do
				expect(Transaction.all).to be_blank
			end

			it 'should destroy its mailboxes' do
				expect(Mailbox.all).to be_blank
			end
		end
  end

  describe '#calculate_refund' do
    before :each do
      @booking = FactoryGirl.create :booking
      @booking.subtotal = 14.2
      @booking.payment_check_succeed
      @time = Time.parse("13:00:00")
    end

    it 'should be zero refund for booking' do
      three_days_time = Date.today + 3 #add 3 days
      @booking.check_in_date = three_days_time
      @booking.check_in_time = @time
      expect(@booking.calculate_refund).to be_eql("0.00")
    end


    it 'should be 50% refund for booking minus phs service fee' do
      eight_days_time = Date.today + 8  #add 8 days
      @booking.check_in_date = eight_days_time
      @booking.check_in_time = @time
      expect(@booking.calculate_refund).to be_eql("6.08")
    end

    it 'should be 100% refund for booking minus phs service fee' do
      fifteen_days_time = Date.today + 15 #add 15 days
      @booking.check_in_date = fifteen_days_time
      @booking.check_in_time = @time
      expect(@booking.calculate_refund).to be_eql("12.08")
    end

  end

  describe '#get_days_left' do
    before :each do
      @booking = FactoryGirl.create :booking
      @booking.amount = 14.2
      @booking.payment_check_succeed
      @time = Time.parse("13:00:00")
    end

    it 'should be 3 days before check in date' do
      three_days_time = Date.today + 3 #add 3 days
      @booking.check_in_date = three_days_time
      @booking.check_in_time = @time
      expect(@booking.get_days_left).to be_eql(3)
    end
  end


  describe '#get_days_before_cancellation' do
    before :each do
      @booking = FactoryGirl.create :booking
      @booking.amount = 14.2
      @booking.guest_cancels_booking
      @time = Time.parse("13:00:00")
    end

    it 'should be 8 days between the cancel date and the check in date' do
      eight_days_time = Date.today + 8 #add 8 days
      @booking.check_in_date = eight_days_time
      @booking.check_in_time = @time
      @booking.cancel_date = Date.today
      expect(@booking.get_days_before_cancellation).to be_eql(8)
    end
  end

  #  def amount_minus_fees
  #return (self.subtotal - self.phs_service_charge)
  #end
  describe '#amount_minus_fees' do
    before :each do
      @booking = FactoryGirl.create :booking
      @booking.subtotal = 14.00
      @booking.payment_check_succeed
    end

    it 'should be 11.92 for booking when subtotal is 14.00' do
      expect(@booking.amount_minus_fees).to be_eql(11.92)
    end
  end

  describe '#unfinished_booking?' do
    before :each do
      @booking = FactoryGirl.create :booking
      @booking.subtotal = 14.00

    end

    it 'should be true when we have create a booking' do
      expect(@booking.unfinished_booking?).to be_truthy
    end

    it 'should be true when we have a payment pending' do
      @booking.try_payment
      expect(@booking.unfinished_booking?).to be_truthy
    end

    it 'should be false when booking succeeds' do
      @booking.payment_check_succeed
      expect(@booking.unfinished_booking?).to be_falsey
    end
  end

  describe '#calculate_host_amount_after_refund' do
    before :each do
      @booking = FactoryGirl.create :booking
      @booking.subtotal = 14.00
      @booking.payment_check_succeed
      @time = Time.parse("13:00:00")
    end

    it 'should be zero host amount for booking' do
      fifteen_days_time = Date.today + 15 #add 15 days
      @booking.check_in_date = fifteen_days_time
      @booking.check_in_time = @time
      expect(@booking.calculate_host_amount_after_guest_cancel).to be_eql("0.00")
    end


    it 'should be 50% host amount for booking minus phs service fee' do
      eight_days_time = Date.today + 8  #add 8 days
      @booking.check_in_date = eight_days_time
      @booking.check_in_time = @time
      expect(@booking.calculate_host_amount_after_guest_cancel).to be_eql("5.08")
    end

    it 'should be 100% amount for host for booking minus phs service fee' do
      three_days_time = Date.today + 3 #add 3 days
      @booking.check_in_date = three_days_time
      @booking.check_in_time = @time
      expect(@booking.calculate_host_amount_after_guest_cancel).to be_eql("11.08")
    end

  end

  describe '#guest_cancelled' do
    before :each do
      @booking = FactoryGirl.create :booking
      @booking.guest_cancels_booking
    end


    it 'should cancel the booking by guest' do
      expect(@booking.human_state_name(@booking.state)).to be_eql('guest has cancelled the booking')
    end

  end

  describe '#host_canceled' do
    before :each do
      @booking = FactoryGirl.create :booking
      @booking.payment_check_succeed #put it in finished state
      @booking.host_accepts_booking #put it into finished_host_accepted state
    end

    it 'should have a request for admin to cancel booking for host' do
      @booking.host_requested_cancellation
      expect(Booking.human_state_name(@booking.state)).to be_eql('host has requested cancellation of this booking')
    end

    it 'should cancel the booking' do
      @booking.host_requested_cancellation
      @booking.admin_cancel_booking
      expect(@booking.human_state_name(@booking.state)).to be_eql('host has cancelled the booking')
    end
  end


  describe '#human_state_name' do #was actual_status
    subject { booking }
    let(:booking) { FactoryGirl.create :booking }

    context 'when a booking is finished' do
      before {
        booking.payment_check_succeed
      }

      it 'should return awaiting host response' do
        expect(Booking.human_state_name(subject.state.to_sym)).to be_eql("awaiting host response")
      end
    end

    context 'when a booking is unfinished' do
      it 'should return "unfinished"' do
        expect(Booking.human_state_name(subject.state.to_sym)).to be_eql("unfinished")
      end
    end

    context 'when a booking is finished and the host has accepted' do
      before {
        booking.payment_check_succeed
        booking.host_accepts_booking
      }
      it 'should return "host accepted but not paid"' do
        expect(Booking.human_state_name(subject.state.to_sym)).to be_eql("host accepted but not paid")
      end
    end

    context 'when a booking is rejected' do
      before {
        booking.payment_check_succeed
        booking.host_rejects_booking
        booking.update_attributes owner_accepted: true, host_accepted: false
      }
      it 'should return "host rejected"' do
        expect(Booking.human_state_name(subject.state.to_sym)).to be_eql("host rejected")
      end
    end

    context 'when a booking has been paid' do
      before {
        booking.payment_check_succeed
        booking.host_accepts_booking
        booking.host_was_paid
        booking.update_attributes owner_accepted: true, host_accepted: true
      }
      it 'should return "host has been paid"' do
        expect(Booking.human_state_name(subject.state.to_sym)).to be_eql("host has been paid")
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
				expect(subject.message).to be_eql(@new_message)
			end

			it 'should create message in mailbox' do
				expect(subject.mailbox.messages.order(:created_at).last.message_text).to be_eql(@new_message)
			end
		end

		context 'when booking already has a message' do
			before do
				@old_message = 'old message'
				subject.message_update(@old_message)
				subject.message_update(@new_message)
			end

			it 'should update the message' do
				expect(subject.message).to be_eql(@new_message)
			end

			it 'should update the mailbox' do
				expect(subject.mailbox.messages.order(:created_at).first.message_text).to be_eql(@new_message)
			end
		end
	end

  describe '#host_cancel?' do
    subject { booking }
    let(:booking) { FactoryGirl.create :booking }

    context 'When a booking has been created booking can not be host canceled by admin' do
      it 'should return host can not cancel' do
        expect(subject.host_cancel?).to be_falsey
      end
    end

    context 'When a booking has been requested to cancel by host host can cancel' do
      before {
        booking.payment_check_succeed
        booking.host_accepts_booking
        booking.host_requested_cancellation
      }
      it 'should return host can cancel' do
        expect(subject.host_cancel?).to be_truthy
      end
    end
  end

  describe '#guest_cancel?' do
    subject { booking }
    let(:booking) { FactoryGirl.create :booking }

    context 'When a booking has been created booking can be canceled by guest' do
      it 'should return host can cancel' do
        expect(subject.guest_cancel?).to be_truthy
      end
    end

    context 'When a booking has been rejected by host, guest cannot cancel' do
      before {
        booking.payment_check_succeed
        booking.host_rejects_booking
      }
      it 'should return guest cannot cancel' do
        expect(subject.guest_cancel?).to be_falsey
      end
    end
  end

  describe '#is_cancelled?' do
    subject { booking }
    let(:booking) { FactoryGirl.create :booking }


    context 'When a booking has been created it is not canceled' do
      it 'should not be canceled' do
        expect(subject.is_cancelled?).to be_falsey
      end
    end

    context 'When a booking has been canceled by a guest it should be canceled' do
      before { booking.guest_cancels_booking }
      it 'should return canceled booking' do
        expect(subject.is_cancelled?).to be_truthy
      end
    end

    context 'When a booking has been canceled by a host it should be canceled' do
      before {
        booking.payment_check_succeed
        booking.host_accepts_booking
        booking.host_requested_cancellation
        booking.admin_cancel_booking

      }
      it 'should return canceled booking' do
        expect(subject.is_cancelled?).to be_truthy
      end
    end
  end

	describe '#bookee and #booker' do
		before :each do
			@booking = FactoryGirl.create :booking
		end

		it 'should have booker i.e. guest' do
			expect(@booking.booker.id).not_to be_blank
		end

		it 'should have bookee i.e. host' do
			expect(@booking.bookee.id).not_to be_blank
		end
	end

	describe '#unfinished' do
		subject { Booking.unfinished }
		context 'when there is no unfinished booking' do
			it 'should return []' do
				expect(subject).to be_blank
			end
		end

		context 'when there is an unfinished booking' do
			before { FactoryGirl.create :booking }
			it 'should return unfinished booking' do
				expect(subject.size).to be_eql(1)
			end
		end
	end

	describe '#needing_host_confirmation' do
		subject { Booking.needing_host_confirmation }
		context 'when no booking needed host confirmation' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				expect(subject).to be_blank
			end
		end

		context 'when there is a booking needed host confirmation' do
			before { FactoryGirl.create :booking, owner_accepted: true, response_id: 0, state: :finished }
			it 'there should be one booking' do
				expect(subject.size).to be_eql(1)
			end
		end
	end

	describe '#declined_by_host' do
		subject { Booking.declined_by_host }
		context 'when no booking declined by host' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				expect(subject).to be_blank
			end
		end

		context 'when there is a booking declined by host' do
			before { FactoryGirl.create :booking, response_id: ReferenceData::Response::UNAVAILABLE.id, state: :finished }
			it 'should return one booking' do
				expect(subject.size).to be_eql(1)
			end
		end
	end

	describe '#required_response' do
		subject { Booking.required_response }
		context 'when no host requires owner to answer his question' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				expect(subject.any?).to be_falsey
			end
		end

		context 'when host wants owner to answer his question' do
			before { FactoryGirl.create :booking, response_id: ReferenceData::Response::QUESTION.id,  state: :finished}
			it 'should return booking' do
				expect(subject.any?).to be_truthy
			end
		end
	end

	describe '#accepted_by_host' do
		subject { Booking.accepted_by_host }
		context 'when no host accepts booking' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				expect(subject.any?).to be_falsey
			end
		end

		context 'when host accepts booking' do
			before { FactoryGirl.create :booking, response_id: ReferenceData::Response::AVAILABLE.id, host_accepted: true, state: :finished_host_accepted }
			it 'should return booking' do
				expect(subject.any?).to be_truthy
			end
		end
	end

	describe '#host_view?' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking }
		context 'when current user is booker i.e. guest' do
			it 'should return false' do
				expect(subject.host_view?(subject.booker)).to be_falsey
			end
		end

		context 'when current user is bookee i.e. host. And guest did not complete the booking.' do
			it 'should return false' do
				expect(subject.host_view?(subject.bookee)).to be_falsey
			end
		end

		context 'when current user is bookee and guest made booking for him' do
			before {
        booking.payment_check_succeed
        booking.update_attributes owner_accepted: true
      }
			it 'should return true' do
				expect(subject.host_view?(subject.bookee)).to be_truthy
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
				expect(subject.owner_view?(subject.bookee)).to be_falsey
			end
		end

		context 'when current user is booker or owner or guest' do
			it 'should return true' do
				expect(subject.owner_view?(subject.booker)).to be_truthy
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
				expect(subject.editable_datetime?(subject.booker)).to be_falsey
			end
		end

		context 'when booking is not finished and it has no enquiry and owner is logged in' do
			it 'should return true' do
				expect(subject.editable_datetime?(subject.booker)).to be_truthy
			end
		end
	end

	describe '#confirmed_by_host' do
		subject { booking }
		let(:booking) { FactoryGirl.create :booking }

		before :each do
			allow(subject).to receive(:complete_transaction).with(booking.bookee).and_return true
		end

		context 'when host confirmed the booking' do
			it 'should return success message' do
				allow(PetOwnerMailer).to receive(:booking_receipt).with(subject).and_return double(:mail, deliver: true)
				booking.check_in_date = Time.now
				booking.check_out_date = Time.now
				booking.homestay = FactoryGirl.create :homestay
				pet = FactoryGirl.create :pet
				booking.booker.pets << pet
				expect(subject.confirmed_by_host(booking.bookee)).to be_eql('You have confirmed the booking')
			end
		end

		context 'when host confirmed unavailability' do
			before { booking.response_id = ReferenceData::Response::UNAVAILABLE.id }

			it 'should return message that guest will be known of your unavailability' do
				allow(PetOwnerMailer).to receive(:provider_not_available).with(subject).and_return double(:mail, deliver: true)
				expect(subject.confirmed_by_host(booking.bookee)).to be_eql('Guest will be informed of your unavailability')
			end
		end

		context 'when host ask a question from guest' do
			before { booking.response_id = ReferenceData::Response::QUESTION.id }

			it 'should return message that guest will have your question' do
				allow(PetOwnerMailer).to receive(:provider_has_question).with(subject, nil).and_return double(:mail, deliver: true)
				expect(subject.confirmed_by_host(booking.bookee)).to be_eql('Your question has been sent to guest')
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
				expect(booking.bookee.notifications?).to be_truthy
			end

			it 'should remove all notification' do
				expect(subject).to be_truthy
				expect(booking.bookee.notifications?).to be_falsey
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
				expect(result.keys).to be_eql([:booking_subtotal, :booking_amount, :transaction_fee, :transaction_actual_amount,
				                           :transaction_time_stamp, :transaction_merchant_fingerprint])
			end
		end

		context 'when any of the required parameters is absent' do
			it 'should return error hash' do
				result = subject.update_transaction_by(nil, Time.now, Time.now + 2.days)
				expect(result.keys).to be_eql([:error])
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
					allow(subject.transaction).to receive(:complete_payment).and_return true
					expect(subject.complete_transaction(subject.bookee)).to be_truthy
				end
			end

			context 'when booking is not finished' do
				it 'should return nil' do
					expect(subject.complete_transaction(subject.bookee)).to be_nil
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
					expect(subject.complete_transaction(subject.booker)).to be_truthy
				end
			end

			context 'when booking is not finished' do
				it 'should return nil' do
					expect(subject.complete_transaction(subject.booker)).to be_nil
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
				expect(booking.amount).to be_eql(61.08)
				expect(booking.phs_service_charge).to be_eql('9.00')
				expect(booking.public_liability_insurance).to be_eql('4.00')
				expect(booking.transaction_fee).to be_eql('1.08')
				expect(subject).to be_eql('47.00')
			end
		end

		describe '#host_booking_status' do
			subject { booking.host_booking_status }

			context 'when status is accepted' do
				before { booking.host_accepted = true }

				it 'should return "Accepted"' do
					expect(subject).to be_eql('Booking $47.00 - Accepted')
				end
			end

			context 'when status is pending' do
				before { booking.host_accepted = false }

				it 'should return "Pending"' do
					expect(subject).to be_eql('Booking $47.00 - Pending')
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
					expect(subject).to be_eql('Booking $47.00 - Rejected')
				end
			end
		end

		describe '#guest_booking_status ' do
			subject { booking.guest_booking_status }

			context 'when status is accepted' do
				before { booking.host_accepted = true }

				it 'should return "Accepted"' do
					expect(subject).to be_eql('Booking $61.08 - Accepted')
				end
			end

			context 'when status is pending' do
				before { booking.host_accepted = false }

				it 'should return "Pending"' do
					expect(subject).to be_eql('Booking $61.08 - Pending')
				end
			end

			context 'when status is rejected' do
				before {
          booking.payment_check_succeed
					booking.host_rejects_booking
					booking.host_accepted = false
				}

				it 'should return "Rejected"' do
					expect(subject).to be_eql('Booking $61.08 - Rejected')
				end
			end
		end

		describe '#fees' do
			subject { booking.fees }

			it 'should return transaction fees paid by guest' do
				expect(subject).to be_eql('1.08')
			end
		end

		describe '#actual_amount' do
			subject { booking.actual_amount }

			it 'will return the transaction amount in string format' do
				expect(subject).to be_eql('61.08')
			end
		end

		describe '#transaction_fee' do
			subject { booking.transaction_fee }

			context 'live mode' do
				before { allow(booking).to receive(:live_mode_rounded_value?).and_return(true) }

				it 'will return transaction value rounded 2 digit with actual cents value' do
					expect(subject).to be_eql('1.50')
				end
			end

			context 'test mode' do
				before { allow(booking).to receive(:live_mode_rounded_value?).and_return(false) }

				it 'will return transaction value rounded 2 digit with actual cents value' do
					expect(subject).to be_eql(1.08.to_s)
				end
			end
		end

	end
end
