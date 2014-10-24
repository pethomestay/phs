require 'spec_helper'
describe User do

  it { should have_one :homestay }
  it { should have_many :pets }
  it { should have_many :enquiries }
  it { should have_many :given_feedbacks }
  it { should have_many :received_feedbacks }
  it { should have_many :bookers }
  it { should have_many :bookees }
  it { should have_many :cards }
  it { should have_many :unavailable_dates }

  let(:user) { FactoryGirl.create :user }
  let(:confirmed_user){ FactoryGirl.create :confirmed_user }


  describe '#name' do
    it 'should concatenate first and last name' do
      User.new(first_name: 'Van', last_name: 'Halen').name.should == 'Van Halen'
    end
  end

  describe '#pet_name' do
    subject { user.pet_name }
    let(:user) { User.new }
    context 'when the user has multiple pets' do
      before { 2.times{user.pets << Pet.new(name: 'fred')} }
      it { should == 'your pets'}
    end
    context 'when the user has one pet' do
      before { user.pets << Pet.new(name: 'fred') }
      it 'should return the pets name' do
        subject.should == 'fred'
      end
    end
  end


  describe '#sanitise' do
    subject { user }

    context 'when the user has their email sanitised' do
      before { user.sanitise }
      it 'should return the sanitised email address' do
        subject.email.should include("@pethomestay.com")
      end
    end
  end


  # When have signed up via Facebook ensure
  # we don't need to put in a password

  describe '#no_password_with_facebook' do
    context 'when signed in with facebook no password required' do
      subject { user }

      before do
        user.password_confirmation = nil
        user.provider ="Facebook"
        user.uid =  "78787878"
      end
      it 'if account linked with Facebook we do not need to enter password' do
          subject.needs_password?.should be_false
      end
    end


    context 'when unlinked with Facebook password required' do

      subject { user }

      let(:user) { FactoryGirl.create :confirmed_user }

      before do
        user.provider ="Facebook"
        user.uid =  "78787878"
        user.unlink_from_facebook
      end
      it 'if account un linked with Facebook we do need to enter password' do
        subject.needs_password?.should be_true
      end
    end


    # When have signed up via the web site
    # we need to put in a password and password confirmation

    context 'when signed with website password required' do
      it 'if we have no facebook link we need to enter a password' do
        confirmed_user.needs_password?.should be_true
      end
    end
  end

	describe '#booking_accepted_by_host' do

		subject { confirmed_user.booking_accepted_by_host }

		context 'when the user booking is not accepted by the host' do
			before { confirmed_user.bookers.create host_accepted: false }
			it 'should not return any booking' do
				subject.any?.should be_false
			end
		end

		context 'when the host accepted the user booking' do

			before do
				booking = FactoryGirl.create :booking, booker: confirmed_user
				booking.update_attributes! host_accepted: true, response_id: 5
			end

			it 'should return user booking which has been accepted by the host' do
				subject.any?.should be_true
			end

		end

	end

	describe '#find_stored_card_id' do
		subject { confirmed_user }
		let(:card) { FactoryGirl.create :card, user: confirmed_user }

		context 'when user has selected stored card' do
			it 'should return selected card id' do
				subject.find_stored_card_id(card.id, nil).should eq(card.id)
			end
		end

		context 'when user has not selected stored card' do
			before { confirmed_user.cards << card }
			it 'should return first card id' do
				subject.find_stored_card_id(nil, '1').should eq(card.id)
			end
		end
	end


  describe "#booking_info_between" do

    before do
      2.times{ |index| FactoryGirl.create(:unavailable_date, date: Date.today + index.day, user: user) }
      2.times{ |index| FactoryGirl.create(:booking, state: :finished_host_accepted , bookee: user, check_in_date: Date.today + (index + 2), check_out_date: Date.today + (index + 3))}
    end

    context "when end date is greater than start date" do

      let(:booking_info){ user.booking_info_between(Date.today - 1.day, Date.today + 4.days) }

      it "should return info of all dates between start and end dates" do
        expect(booking_info.count).to eq(6)
      end

      it "should return users unavailable dates info between start and end dates" do
        first_unavailable_date = user.unavailable_dates.first
        expect(booking_info).to include({
          id: first_unavailable_date.id,
          title: "Unavailable",
          start: first_unavailable_date.date.strftime("%Y-%m-%d"),
        })
        last_unavailable_date = user.unavailable_dates.first
        expect(booking_info).to include({
          id: last_unavailable_date.id,
          title: "Unavailable",
          start: last_unavailable_date.date.strftime("%Y-%m-%d"),
        })
      end

      it "should return users available dates info between start and end dates" do
        first_available_date = Date.today - 1
        expect(booking_info).to include({
          title: "Available",
          start: first_available_date.strftime("%Y-%m-%d"),
        })
        last_available_date = Date.today + 4
        expect(booking_info).to include({
          title: "Available",
          start: last_available_date.strftime("%Y-%m-%d"),
        })
      end

      it "should return users booked dates in full calendar event format" do
        expect(booking_info).to include({
          title: "Booked",
          start: (Date.today + 2).strftime("%Y-%m-%d")
        })
      end

    end

    context "when start date is greater than end date" do

      let(:booking_info){ confirmed_user.booking_info_between(Date.today + 2.days, Date.today) }

      it "should return a blank array" do
        expect(booking_info).to be_blank
      end

    end

   describe "#unavailable_dates_info" do
     it "should return unavilable dates in fullcalendar event format" do
       date = FactoryGirl.create(:unavailable_date, date: Date.today, user: confirmed_user)
       expect(confirmed_user.unavailable_dates_info(Date.today, Date.today)).to eq([{ id: date.id, title: "Unavailable", start: Date.today.strftime("%Y-%m-%d") }])
     end
   end

   describe "#booked_dates" do

     let(:booking_date_ranges){
       [
         [(Date.today - 1), (Date.today + 1)],
         [(Date.today + 3), (Date.today + 7)],
         [(Date.today + 2), (Date.today + 8)]
       ]
     }
     let(:all_booked_dates){
       booking_date_ranges.collect{ |date_arr| (date_arr[0]..(date_arr[1] - 1)).to_a }.flatten.uniq
     }

     before do
       3.times.collect{ |index|
         FactoryGirl.create(:booking, state: :finished_host_accepted, bookee: confirmed_user, check_in_date: booking_date_ranges[index][0], check_out_date: booking_date_ranges[index][1])
       }
     end

     context "when start_date is greater than check in date of any booking" do
       it "should return all booked dates for the user within the passed range" do
         b_dates = confirmed_user.booked_dates_between(Date.today, Date.today + 30)
         expect(b_dates).to eq(all_booked_dates - [Date.today - 1])
       end
     end

     context "when end_date  is lesser than check out date of any booking" do
       it "should return all booked dates for the user within the passed range" do
         b_dates = confirmed_user.booked_dates_between(Date.today - 2, Date.today + 5)
         expect(b_dates).to eq(all_booked_dates - [Date.today + 6, Date.today + 7] )
       end
     end

     context "when start_date < check_in_date and end_date > check_out_date" do
       it "should return all booked dates for the user within the passed range" do
         b_dates = confirmed_user.booked_dates_between(Date.today - 2, Date.today + 30)
         expect(b_dates).to eq(all_booked_dates)
       end
     end

   end

   describe "#booked_dates_info" do
     it "should return booked dates in fullcalendar event format" do
       FactoryGirl.create(:booking, state: :finished_host_accepted, bookee: confirmed_user, check_in_date: Date.today, check_out_date: Date.today + 1)
       expected_result = [{ title: "Booked", start: Date.today.strftime("%Y-%m-%d") }]
       expect(confirmed_user.booked_dates_info((Date.today - 1), (Date.today + 1))).to eq(expected_result)
     end
   end

  end

  describe "#unavailable_dates_between" do

    let(:checkin_date) { Date.today - 1.day }
    let(:checkout_date) { Date.today + 2.days }

    subject { user.unavailable_dates_between(checkin_date, checkout_date) }

    context "when user is neither booked nor unavailable between checkin date and checkout date" do
      it "should return a blank array" do
        expect(subject).to be_blank
      end
    end

    context "when user is booked between checkin and checkout date" do
      it "should return the booked dates" do
        booking = FactoryGirl.create(:booking, state: :finished_host_accepted, bookee: user, check_in_date: checkin_date , check_out_date: checkin_date)
        expect(subject).to eq([booking.check_in_date])
      end
    end

    context "when user is unavailable between start date and end date" do
      it "should return unavailable dates" do
        unavailable_date = FactoryGirl.create(:unavailable_date, date: checkin_date + 1.day, user: user)
        expect(subject).to eq([unavailable_date.date])
      end
    end

    context "when user is unavailable on checkout date" do
      it "should return a blank array" do
        unavailable_date = FactoryGirl.create(:unavailable_date, date: checkout_date, user: user)
        expect(subject).to be_blank
      end
    end

    context "when user is booked on checkout date" do
      it "should return a blank array" do
        booking = FactoryGirl.create(:booking, state: :finished_host_accepted, bookee: user, check_in_date: checkout_date , check_out_date: checkout_date)
        expect(subject).to be_blank
      end
    end

  end

  describe "#unavailable_dates_after" do

    let(:start_date) { Date.today }

    subject { user.unavailable_dates_after(start_date) }

    context "when user is neither booked nor unavailable after start date" do
      it "should return a blank array" do
        expect(subject).to be_blank
      end
    end

    context "when user is booked after start date" do

      it "should return booked date" do
        booking = FactoryGirl.create(:booking, state: :finished_host_accepted, bookee: user, check_in_date: start_date , check_out_date: start_date)
        expect(subject).to eq([booking.check_in_date])
      end

      context "when check in date is less than start date" do
        it "should return all dates between start date and checkout date" do
          booking = FactoryGirl.create(:booking, state: :finished_host_accepted, bookee: user, check_in_date: start_date - 1.day , check_out_date: start_date + 2.days)
          expect(subject).to eq((start_date..(start_date + 1.day)).to_a)
        end
      end

      context "when check in date is greater than or equal start date" do
        it "should return all dates between checkin date and checkout date" do
          booking = FactoryGirl.create(:booking, state: :finished_host_accepted, bookee: user, check_in_date: start_date , check_out_date: start_date + 2.days)
          expect(subject).to eq((start_date..(start_date + 1.day)).to_a)
        end
      end

    end

    context "when user is unavailable after start date" do
      it "should return unavailable date" do
        unavailable_date = FactoryGirl.create(:unavailable_date, date: start_date + 1.day, user: user)
        expect(subject).to eq([unavailable_date.date])
      end
    end

  end

  describe "#update_calendar" do
    it "should mark calendar as updated" do
      confirmed_user.update_calendar
      expect(confirmed_user.calendar_updated_at).to eq(Date.today)
    end
  end
end
