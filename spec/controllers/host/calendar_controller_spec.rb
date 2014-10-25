require 'spec_helper'

describe Host::CalendarController, :type => :controller do
  login_user
  before :each do
    subject.current_user.homestay = FactoryGirl.create(:homestay)
  end
  let(:guest) { FactoryGirl.create :confirmed_user }

  describe 'GET #availability' do
    def create_booking_then_fetch(in_d, out_d, start_d, end_d)
      FactoryGirl.create :booked_booking,
                         booker: guest,
                         bookee: subject.current_user,
                         check_in_date:  Date.parse(in_d),
                         check_out_date: Date.parse(out_d)

      get  :availability, start: start_d, end: end_d
    end

    context 'when nothing is in database' do
      it 'returns an empty array in json' do
        get  :availability, start: '2015-10-01', end: '2015-10-30'

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when one irrelevent record is in database' do
      it 'returns an empty array in json' do
        in_d    = '2015-10-02'; out_d = '2015-10-07'
        start_d = '2015-10-01'; end_d = '2015-10-08'
        FactoryGirl.create :booked_booking,
                         booker: subject.current_user,
                         bookee: guest,
                         check_in_date:  Date.parse(in_d),
                         check_out_date: Date.parse(out_d)

        get  :availability, start: start_d, end: end_d

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when check_out_d < start_d' do
      it 'returns an empty array in json ' do
        in_d    = '2015-10-01'; out_d = '2015-10-07'
        start_d = '2015-10-08'; end_d = '2015-10-30'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when end_d < check_in_d' do
      it 'returns an empty array in json ' do
        in_d    = '2015-10-09'; out_d = '2015-10-17'
        start_d = '2015-10-01'; end_d = '2015-10-08'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when check_in_d < start_d < check_out_d < end_d' do
      it 'returns start_d..check_out_d in json' do
        in_d    = '2015-10-01'; out_d = '2015-10-15'
        start_d = '2015-10-08'; end_d = '2015-10-30'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expected = (start_d..out_d).collect do |d|
          {
            date: d,
            status: 'booked'
          }
        end.to_json
        expect(response.body).to eq expected
      end
    end

    context 'when start_d < check_in_d < end_d < check_out_d' do
      it 'returns start_d..check_out_d in json' do
        in_d    = '2015-10-05'; out_d = '2015-10-30'
        start_d = '2015-10-01'; end_d = '2015-10-15'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expected = (in_d..end_d).collect do |d|
          {
            date: d,
            status: 'booked'
          }
        end.to_json
        expect(response.body).to eq expected
      end
    end

    context 'when start_d < check_in_d < check_out_d < end_d' do
      it 'returns check_in_d..check_out_d in json' do
        in_d    = '2015-10-08'; out_d = '2015-10-15'
        start_d = '2015-10-01'; end_d = '2015-10-30'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expected = (in_d..out_d).collect do |d|
          {
            date: d,
            status: 'booked'
          }
        end.to_json
        expect(response.body).to eq expected
      end
    end

    context 'when check_in_d < start_d < end_d < check_out_d' do
      it 'returns start_d..end_d in json' do
        in_d    = '2015-10-01'; out_d = '2015-10-30'
        start_d = '2015-10-05'; end_d = '2015-10-15'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expected = (start_d..end_d).collect do |d|
          {
            date: d,
            status: 'booked'
          }
        end.to_json
        expect(response.body).to eq expected
      end
    end

    context 'when booking last for only 1 day b/f start_d' do
      it 'returns an empty array in json' do
        in_d    = '2015-10-01'; out_d = '2015-10-01'
        start_d = '2015-10-15'; end_d = '2015-10-30'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when booking last for only 1 day after end_d' do
      it 'returns an empty array in json' do
        in_d    = '2015-10-30'; out_d = '2015-10-30'
        start_d = '2015-10-01'; end_d = '2015-10-15'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expect(response.body).to eq([].to_json)
      end
    end

    context 'when booking last for only 1 day on start_d' do
      it 'returns the booking date in json' do
        in_d    = '2015-10-15'; out_d = '2015-10-15'
        start_d = '2015-10-15'; end_d = '2015-10-30'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expected = [
          {
            date: in_d,
            status: 'booked'
          }
        ].to_json
        expect(response.body).to eq expected
      end
    end

    context 'when booking last for only 1 day on end_d' do
      it 'returns the booking date in json' do
        in_d    = '2015-10-30'; out_d = '2015-10-30'
        start_d = '2015-10-15'; end_d = '2015-10-30'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expected = [
          {
            date: end_d,
            status: 'booked'
          }
        ].to_json
        expect(response.body).to eq expected
      end
    end

    context 'when booking last for only 1 day b/w start_d & end_d' do
      it 'returns the booking date in json' do
        in_d    = '2015-10-15'; out_d = '2015-10-15'
        start_d = '2015-10-01'; end_d = '2015-10-30'

        create_booking_then_fetch(in_d, out_d, start_d, end_d)

        expected = [
          {
            date: in_d,
            status: 'booked'
          }
        ].to_json
        expect(response.body).to eq expected
      end
    end

    context 'when two bookings overlap' do
      it 'returns unique combined booking dates in json' do
        in_d_1  = '2015-10-10'; out_d_1 = '2015-10-20'
        in_d_2  = '2015-10-05'; out_d_2 = '2015-10-15'
        start_d = '2015-10-01'; end_d   = '2015-10-30'
        FactoryGirl.create :booked_booking,
                           booker: guest,
                           bookee: subject.current_user,
                           check_in_date:  Date.parse(in_d_1),
                           check_out_date: Date.parse(out_d_1)
        FactoryGirl.create :booked_booking,
                           booker: guest,
                           bookee: subject.current_user,
                           check_in_date:  Date.parse(in_d_2),
                           check_out_date: Date.parse(out_d_2)

        get  :availability, start: start_d, end: end_d

        expected = (in_d_2..out_d_1).collect do |d|
          {
            date: d,
            status: 'booked'
          }
        end.to_json
        expect(response.body).to eq expected
      end
    end

    context 'when unavailable date is b/w start_d & end_d' do
      it 'returns the unavailable date in json' do
        u_d    = '2015-10-15'; u_d_id = 55
        start_d = '2015-10-01'; end_d = '2015-10-30'
        FactoryGirl.create :unavailable_date,
                           id: u_d_id,
                           date: Date.parse(u_d),
                           user: subject.current_user

        get  :availability, start: start_d, end: end_d

        expected = [
          {
            date: u_d,
            status: 'unavailable',
            unavailable_date_id: u_d_id,
          }
        ].to_json
        expect(response.body).to eq expected
      end
    end

    context 'when unavailable date is on start_d' do
      it 'returns the unavailable date in json' do
        u_d    = '2015-10-01'; u_d_id = 55
        start_d = '2015-10-01'; end_d = '2015-10-30'
        FactoryGirl.create :unavailable_date,
                           id: u_d_id,
                           date: Date.parse(u_d),
                           user: subject.current_user

        get  :availability, start: start_d, end: end_d

        expected = [
          {
            date: u_d,
            status: 'unavailable',
            unavailable_date_id: u_d_id,
          }
        ].to_json
        expect(response.body).to eq expected
      end
    end

    context 'when unavailable date is on end_d' do
      it 'returns the unavailable date in json' do
        u_d    = '2015-10-30'; u_d_id = 55
        start_d = '2015-10-01'; end_d = '2015-10-30'
        FactoryGirl.create :unavailable_date,
                           id: u_d_id,
                           date: Date.parse(u_d),
                           user: subject.current_user

        get  :availability, start: start_d, end: end_d

        expected = [
          {
            date: u_d,
            status: 'unavailable',
            unavailable_date_id: u_d_id,
          }
        ].to_json
        expect(response.body).to eq expected
      end
    end

    context 'when unavailable date is b/f start_d' do
      it 'returns an empty array in json' do
        u_d    = '2015-10-01'; u_d_id = 55
        start_d = '2015-10-10'; end_d = '2015-10-30'
        FactoryGirl.create :unavailable_date,
                           id: u_d_id,
                           date: Date.parse(u_d),
                           user: subject.current_user

        get  :availability, start: start_d, end: end_d

        expected = [].to_json
        expect(response.body).to eq expected
      end
    end

    context 'when unavailable date is after end_d' do
      it 'returns an empty array in json' do
        u_d    = '2015-11-01'; u_d_id = 55
        start_d = '2015-10-10'; end_d = '2015-10-30'
        FactoryGirl.create :unavailable_date,
                           id: u_d_id,
                           date: Date.parse(u_d),
                           user: subject.current_user

        get  :availability, start: start_d, end: end_d

        expected = [].to_json
        expect(response.body).to eq expected
      end
    end
  end
end
