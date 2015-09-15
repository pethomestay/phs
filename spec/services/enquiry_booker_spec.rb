require 'rails_helper'

RSpec.describe EnquiryBooker do
  let(:user) { create :user }
  let(:homestay) { create :homestay, user: user, for_charity: true }
  let(:enquiry) { build :enquiry, user: user, homestay: homestay }
  let(:booker) { EnquiryBooker.new(enquiry, homestay) }

  describe '#initialize' do
    it 'sets enquiry' do
      expect(booker.enquiry).to_not eq nil
    end

    it 'sets homestay' do
      expect(booker.homestay).to_not eq nil
    end

    it 'sets booking' do
      expect(booker.booking).to_not eq nil
    end
  end

  describe '#book' do
    before :each do
      allow(enquiry).to receive(:send_new_enquiry_notifications).and_return(true)
      allow(enquiry).to receive(:send_new_enquiry_notification_SMS).and_return(true)
    end

    it 'creates a booking' do
      expect{ booker.book }.to change(Booking, :count).by 1
    end

    it 'sets booking details' do
      expect(booker.book.attributes).to include({
        "check_in_date" => be_present,
        "number_of_nights" => 1,
        "subtotal" => be_present,
        "bookee_id" => be_present,
        "booker_id" => be_present,
        "check_in_date" => be_present,
        "check_in_time" => be_present,
        "check_out_date" => be_present,
        "check_out_time" => be_present
      })
    end
  end
end
