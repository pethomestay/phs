require 'spec_helper'
require 'pry'
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
        subject.email.should include("@tapmint.com")
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
			before { user.bookers.create host_accepted: false }
			it 'should not return any booking' do
				subject.any?.should be_false
			end
		end

		context 'when the host accepted the user booking' do

			before do
				booking = FactoryGirl.create :booking, booker: user
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
    end

    context "when end date is greater than start date" do

      let(:booking_info){ confirmed_user.booking_info_between(Date.today - 1.day, Date.today + 2.days) }
    
      it "should return info of all dates between start and end dates" do
        expect(booking_info.count).to eq(4)
      end

      it "should return users unavailable dates info between start and end dates" do
        first_unavailable_date = user.unavailable_dates.first
        expect(booking_info).to include({
          id: first_unavailable_date.id,
          title: "Unavailable",
          start: first_unavailable_date.date.strftime("%Y-%m-%d"),
          end: first_unavailable_date.date.strftime("%Y-%m-%d")
        })
        last_unavailable_date = user.unavailable_dates.first
        expect(booking_info).to include({
          id: last_unavailable_date.id,
          title: "Unavailable",
          start: last_unavailable_date.date.strftime("%Y-%m-%d"),
          end: last_unavailable_date.date.strftime("%Y-%m-%d")
        })
      end

      it "should return users available dates info between start and end dates" do
        first_available_date = Date.today - 1
        expect(booking_info).to include({
          title: "Available",
          start: first_available_date.strftime("%Y-%m-%d"),
          end: first_available_date.strftime("%Y-%m-%d")
        })
        last_available_date = Date.today + 2
        expect(booking_info).to include({
          title: "Available",
          start: last_available_date.strftime("%Y-%m-%d"),
          end: last_available_date.strftime("%Y-%m-%d")
        })
      end

    end

    context "when start date is greater than end date" do

      let(:booking_info){ confirmed_user.booking_info_between(Date.today + 2.days, Date.today) }

      it "should return a blank array" do
        expect(booking_info).to be_blank
      end

    end

  end


  describe "#update_calendar" do
    it "should mark calendar as updated" do
      time = Time.now
      Time.stub(:now).and_return(time)
      confirmed_user.update_calendar
      expect(confirmed_user.calendar_updated_at).to eq(time)
    end
  end
end
