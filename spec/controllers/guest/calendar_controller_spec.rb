require 'spec_helper'

describe Guest::CalendarController do
  login_user
  let(:host) { FactoryGirl.create :confirmed_user }

  describe 'GET #availability' do
    def fetch_availability(in_d, out_d, start_d, end_d)
      booking = FactoryGirl.create :booked_booking,
                         booker: subject.current_user,
                         check_in_date:  Date.parse(in_d),
                         check_out_date: Date.parse(out_d)

      get  :availability, start: start_d, end: end_d
      booking
    end

    context 'when nothing is in database' do
      it 'returns an empty array in json' do
        get  :availability, start: '2014-10-01', end: '2014-10-30'

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when one irrelevent record is in database' do
      it 'returns an empty array in json' do
        in_d    = '2014-10-02'; out_d = '2014-10-07'
        start_d = '2014-10-01'; end_d = '2014-10-08'

        FactoryGirl.create :booked_booking,
                         booker: host,
                         bookee: subject.current_user,
                         check_in_date:  Date.parse(in_d),
                         check_out_date: Date.parse(out_d)

        get  :availability, start: start_d, end: end_d

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when check_out_d < start_d' do
      it 'returns an empty array in json ' do
        in_d    = '2014-10-01'; out_d = '2014-10-07'
        start_d = '2014-10-08'; end_d = '2014-10-30'

        fetch_availability(in_d, out_d, start_d, end_d)

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when end_d < check_in_d' do
      it 'returns an empty array in json ' do
        in_d    = '2014-10-09'; out_d = '2014-10-17'
        start_d = '2014-10-01'; end_d = '2014-10-08'

        fetch_availability(in_d, out_d, start_d, end_d)

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when check_in_d < start_d < check_out_d < end_d' do
      it 'returns start_d..check_out_d in json' do
        in_d    = '2014-10-01'; out_d = '2014-10-15'
        start_d = '2014-10-08'; end_d = '2014-10-30'

        booking = fetch_availability(in_d, out_d, start_d, end_d)

        expected = (start_d..out_d).collect do |d|
          {
            date: d,
            status: 'booked',
            booking_id: booking.id
          }
        end.to_json
        expect(response.body).to eq expected
      end
    end

    context 'when start_d < check_in_d < end_d < check_out_d' do
      it 'returns start_d..check_out_d in json' do
        in_d    = '2014-10-05'; out_d = '2014-10-30'
        start_d = '2014-10-01'; end_d = '2014-10-15'

        booking = fetch_availability(in_d, out_d, start_d, end_d)

        expected = (in_d..end_d).collect do |d|
          {
            date: d,
            status: 'booked',
            booking_id: booking.id
          }
        end.to_json
        expect(response.body).to eq expected
      end
    end

    context 'when start_d < check_in_d < check_out_d < end_d' do
      it 'returns check_in_d..check_out_d in json' do
        in_d    = '2014-10-08'; out_d = '2014-10-15'
        start_d = '2014-10-01'; end_d = '2014-10-30'

        booking = fetch_availability(in_d, out_d, start_d, end_d)

        expected = (in_d..out_d).collect do |d|
          {
            date: d,
            status: 'booked',
            booking_id: booking.id
          }
        end.to_json
        expect(response.body).to eq expected
      end
    end

    context 'when check_in_d < start_d < end_d < check_out_d' do
      it 'returns start_d..end_d in json' do
        in_d    = '2014-10-01'; out_d = '2014-10-30'
        start_d = '2014-10-05'; end_d = '2014-10-15'

        booking = fetch_availability(in_d, out_d, start_d, end_d)

        expected = (start_d..end_d).collect do |d|
          {
            date: d,
            status: 'booked',
            booking_id: booking.id
          }
        end.to_json
        expect(response.body).to eq expected
      end
    end

    context 'when booking last for only 1 day b/f start_d' do
      it 'returns an empty array in json' do
        in_d    = '2014-10-01'; out_d = '2014-10-01'
        start_d = '2014-10-15'; end_d = '2014-10-30'

        fetch_availability(in_d, out_d, start_d, end_d)

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when booking last for only 1 day after end_d' do
      it 'returns an empty array in json' do
        in_d    = '2014-10-30'; out_d = '2014-10-30'
        start_d = '2014-10-01'; end_d = '2014-10-15'

        fetch_availability(in_d, out_d, start_d, end_d)

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when booking last for only 1 day on start_d' do
      it 'returns the booking date in json' do
        in_d    = '2014-10-15'; out_d = '2014-10-15'
        start_d = '2014-10-15'; end_d = '2014-10-30'

        booking = fetch_availability(in_d, out_d, start_d, end_d)

        expected = [
          {
            date: in_d,
            status: 'booked',
            booking_id: booking.id
          }
        ].to_json
        expect(response.body).to eq expected
      end
    end

    context 'when booking last for only 1 day on end_d' do
      it 'returns the booking date in json' do
        in_d    = '2014-10-30'; out_d = '2014-10-30'
        start_d = '2014-10-15'; end_d = '2014-10-30'

        booking = fetch_availability(in_d, out_d, start_d, end_d)

        expected = [
          {
            date: end_d,
            status: 'booked',
            booking_id: booking.id
          }
        ].to_json
        expect(response.body).to eq expected
      end
    end

    context 'when booking last for only 1 day b/w start_d & end_d' do
      it 'returns the booking date in json' do
        in_d    = '2014-10-15'; out_d = '2014-10-15'
        start_d = '2014-10-01'; end_d = '2014-10-30'

        booking = fetch_availability(in_d, out_d, start_d, end_d)

        expected = [
          {
            date: in_d,
            status: 'booked',
            booking_id: booking.id
          }
        ].to_json
        expect(response.body).to eq expected
      end
    end
  end
end
