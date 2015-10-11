require 'rails_helper'

RSpec.describe Scheduler do
  let(:user) { create :user }
  let(:scheduler) { Scheduler.new(user, start_date: DateTime.current - 7.days, end_date: DateTime.current + 2.days) }

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

  describe '#booked_date_values' do
    context 'with booked dates' do
      let!(:booking) { create :booking, bookee: user, booker: user, check_in_date: DateTime.current.to_date }

      context 'with check in and check out date in the same day' do
        it 'returns array of check in date' do
          booking.update_column(:state, "finished_host_accepted")
          expect(scheduler.booked_date_values).to eq [booking.check_in_date]
        end
      end

      context 'with different check in and check out dates' do
        let(:expected_dates) { (DateTime.current.to_date - 3.days)..(DateTime.current.to_date - 1.day) }
        it 'returns array of booked dates' do
          booking.update_attributes!(check_in_date: DateTime.current.to_date - 3.days)
          booking.update_column(:state, "finished_host_accepted")
          expect(scheduler.booked_date_values).to eq expected_dates.to_a
        end
      end
    end

    context 'without booked_dates' do
      it 'returns empty array' do
        expect(scheduler.booked_date_values).to eq []
      end
    end
  end

  describe '#booked_dates_info' do
    let!(:booking) { create :booking, bookee: user, booker: user, check_in_date: DateTime.current.to_date }

    it 'returns booked dates in hash format' do
      booking.update_column(:state, "finished_host_accepted")
      expect(scheduler.booked_dates_info).to include({
        title: "Booked",
        start: booking.check_in_date.strftime("%Y-%m-%d")
      })
    end
  end

  describe '#booking_info' do
    let!(:unavailable_date) { create :unavailable_date, user: user }
    let!(:booking) { create :booking, bookee: user, booker: user, check_in_date: DateTime.current.to_date }

    it 'includes available dates' do
      expect(scheduler.booking_info).to include({
        title: 'Available',
        start: be_present
      })
    end

    it 'includes unavailable dates' do
      expect(scheduler.booking_info).to include({
        id: be_present,
        title: 'Unavailable',
        start: be_present
      })
    end

    it 'includes booked dates' do
      booking.update_column(:state, "finished_host_accepted")
      expect(scheduler.booking_info).to include({
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

  describe '#blocked_date_values' do
    let!(:unavailable_date) { create :unavailable_date, :without_validation, user: user }
    let!(:booking) { create :booking, bookee: user, booker: user }

    it 'includes unavailable dates' do
      expect(scheduler.blocked_date_values).to include(unavailable_date.date)
    end

    it 'includes booked dates' do
      booking.update_column(:state, "finished_host_accepted")
      expect(scheduler.blocked_date_values).to include(booking.check_in_date)
    end
  end
end
