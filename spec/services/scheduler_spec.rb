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

  describe '#booking_info_between'
  describe '#booked_dates_info'
  describe '#unavailable_dates_after'
  describe '#unavailable_dates_between'
end
