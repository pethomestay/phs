require 'rails_helper'

RSpec.describe Scheduler do
  let(:user) { create :user }
  let(:scheduler) { Scheduler.new(user, start_date: DateTime.now - 7.days, end_date: DateTime.now + 2.days) }

  describe '#initialize' do
    it 'sets schedulable' do
      expect(scheduler.schedulable).to_not eq nil
    end

    it 'sets start date' do
      expect(scheduler.start_date).to_not eq nil
    end

    it 'sets end date' do
      expect(scheduler.end_date).to_not eq nil
    end
  end

  describe '#unavailable_dates_info' do
    context 'with unavailable_dates' do
      let!(:unavailable_date) { create :unavailable_date, user: user }

      it 'returns unavailable dates in hash format' do
        expect(scheduler.unavailable_dates_info).to include({
          id: unavailable_date.id,
          title: 'Unavailable',
          start: unavailable_date.date.strftime("%Y-%m-%d")
        })
      end
    end

    context 'without unavailable_dates' do
      it 'returns an empty array' do
        expect(scheduler.unavailable_dates_info).to eq([])
      end
    end
  end

  describe '#booked_dates_between' do
    context 'with booked dates' do
      let!(:booking) { create :booking, bookee: user, booker: user, check_in_date: DateTime.now.to_date }

      context 'with check in and check out date in the same day' do
        it 'returns array of check in date' do
          booking.update_column(:state, "finished_host_accepted")
          expect(scheduler.booked_dates_between).to eq [booking.check_in_date]
        end
      end

      context 'with different check in and check out dates' do
        let(:expected_dates) { (DateTime.now.to_date - 3.days)..(DateTime.now.to_date - 1.day) }
        it 'returns array of booked dates' do
          booking.update_attributes!(check_in_date: DateTime.now.to_date - 3.days)
          booking.update_column(:state, "finished_host_accepted")
          expect(scheduler.booked_dates_between).to eq expected_dates.to_a
        end
      end
    end

    context 'without booked_dates' do
      it 'returns empty array' do
        expect(scheduler.booked_dates_between).to eq []
      end
    end
  end

  describe '#booked_dates_info' do
    let!(:booking) { create :booking, bookee: user, booker: user, check_in_date: DateTime.now.to_date }

    it 'returns booked dates in hash format' do
      booking.update_column(:state, "finished_host_accepted")
      expect(scheduler.booked_dates_info).to include({
        title: "Booked",
        start: booking.check_in_date.strftime("%Y-%m-%d")
      })
    end
  end

  describe '#booking_info_between' do
    let!(:unavailable_date) { create :unavailable_date, user: user }
    let!(:booking) { create :booking, bookee: user, booker: user, check_in_date: DateTime.now.to_date }

    it 'includes available dates' do
      expect(scheduler.booking_info_between).to include({
        title: 'Available',
        start: be_present
      })
    end

    it 'includes unavailable dates' do
      expect(scheduler.booking_info_between).to include({
        id: be_present,
        title: 'Unavailable',
        start: be_present
      })
    end

    it 'includes booked dates' do
      booking.update_column(:state, "finished_host_accepted")
      expect(scheduler.booking_info_between).to include({
        title: "Booked",
        start: be_present
      })
    end
  end

  describe '#available_dates_info' do
    it 'returns available dates in hash format' do
      expect(scheduler.available_dates_info).to include({
        title: 'Available',
        start: be_present
      })
    end
  end

  describe '#unavailable_dates_between' do
    let!(:unavailable_date) { create :unavailable_date, user: user }
    let!(:booking) { create :booking, bookee: user, booker: user, check_in_date: DateTime.now.to_date }

    it 'includes unavailable dates' do
      expect(scheduler.unavailable_dates_between).to include(unavailable_date.date)
    end

    it 'includes booked dates' do
      booking.update_column(:state, "finished_host_accepted")
      expect(scheduler.unavailable_dates_between).to include(booking.check_in_date)
    end
  end
end
