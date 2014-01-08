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

	describe '#booking_accepted_by_host' do
		subject { user.booking_accepted_by_host }
		let(:user) { FactoryGirl.create :user }
		context 'when the user booking is not accepted by the host' do
			before { user.bookers.create host_accepted: false }
			it 'should not return any booking' do
				subject.any?.should be_false
			end
		end
		context 'when the host accepted the user booking' do
			before { user.bookers.create host_accepted: true, response_id: 5 }
			it 'should return user booking which has been accepted by the host' do
				subject.any?.should be_true
			end
		end
	end
end
