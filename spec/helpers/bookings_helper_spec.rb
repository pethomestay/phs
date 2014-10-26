

# Specs in this file have access to a helper object that includes
# the BookingsHelper. For example:
#
# describe BookingsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe BookingsHelper, :type => :helper do
  let(:user){ FactoryGirl.build(:user, id: 1) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end


  describe '#canceled' do
    let(:booking) { FactoryGirl.create :booking }
    it "saves a new status to booking object" do
      expect(helper.canceled(booking.id, false).state).to eql('guest_cancelled')
    end
  end

  describe '#can_host_request_cancel_any_bookings?' do
    subject { helper.can_host_request_cancel_any_bookings? }
    let(:booking) { FactoryGirl.create :booking }

    context "it should be false when I set the status to 'finished'" do
      before do
        booking.payment_check_succeed
      end
      it {is_expected.to be_falsey }
    end

    context "it should be true when I set the status to 'finished_host_accepted'" do
      before do
        booking.payment_check_succeed
        booking.host_accepts_booking
        booking.bookee = user
        booking.save
      end
      it {is_expected.to be_truthy }
    end
  end

  describe '#is_canceled_booking?' do
    subject { helper.is_canceled_booking? booking }
    let(:booking) { FactoryGirl.create :booking }
    context "it should be false when I set the status to 'finished'" do
      before do
        booking.payment_check_succeed
      end
      it {is_expected.to be_falsey }
    end

    context "it should be true when I set the status to 'guest_cancelled'" do
      before do
        booking.guest_cancels_booking
      end
      it {is_expected.to be_truthy }
    end


  end



  describe '#booking_status_for_listing' do
    subject { helper.booking_status_for_listing booking }

    context 'when a host has canceled the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.payment_check_succeed
        booking.host_accepts_booking
        booking.host_requested_cancellation
        booking.admin_cancel_booking
      end

      it { is_expected.to eql 'Host cancelled' }
    end

    context 'when a host has requested to cancel the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.payment_check_succeed
        booking.host_accepts_booking
        booking.host_requested_cancellation
      end

      it { is_expected.to eql 'Host requested cancellation' }
    end

    context 'when a guest has canceled the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.guest_cancels_booking
      end

      it { is_expected.to eql 'Guest cancelled' }
    end

    context 'when a host has accepted the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.payment_check_succeed
        booking.host_accepts_booking
        booking.host_accepted = true
      end

      it { is_expected.to eql 'Confirmed' }
    end

    context 'when a host has not accepted the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.payment_check_succeed
        booking.host_accepted = false
      end

      it { is_expected.to eql 'Unconfirmed' }
    end
  end

end
