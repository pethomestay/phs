require 'spec_helper'

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
describe BookingsHelper do

  describe '#canceled' do
    let(:booking) { FactoryGirl.create :booking }
    it "saves a new status to booking object" do

      helper.canceled(booking.id, BOOKING_STATUS_GUEST_CANCELED)
      booking.status.should eql(BOOKING_STATUS_GUEST_CANCELED)
    end
  end

  describe '#is_canceled_booking?' do
    subject { helper.is_canceled_booking? booking }
    let(:booking) { FactoryGirl.create :booking }
    context "it should be false when I set the status to 'finished'" do
      before do
        booking.status = BOOKING_STATUS_FINISHED
      end
      it {should be_false }
    end

    context "it should be true when I set the status to 'guest_canceled'" do
      before do
        booking.status = BOOKING_STATUS_GUEST_CANCELED
      end
      it {should be_true }
    end


  end


  describe '#booking_status_for_listing' do
    subject { helper.booking_status_for_listing booking }

    context 'when a host has canceled the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.status = BOOKING_STATUS_HOST_CANCELED
      end

      it { should eql 'Host cancelled' }
    end

    context 'when a host has requested to cancel the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.status = HOST_HAS_REQUESTED_CANCELLATION
      end

      it { should eql 'Host requested cancellation' }
    end

    context 'when a guest has canceled the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.status = BOOKING_STATUS_GUEST_CANCELED
      end

      it { should eql 'Guest cancelled' }
    end

    context 'when a host has accepted the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.status = BOOKING_STATUS_FINISHED
        booking.host_accepted = true
      end

      it { should eql 'Confirmed' }
    end

    context 'when a host has not accepted the booking' do
      let(:booking) { FactoryGirl.create :booking }
      before do
        booking.status = BOOKING_STATUS_FINISHED
        booking.host_accepted = false
      end

      it { should eql 'Unconfirmed' }
    end

  end



end
