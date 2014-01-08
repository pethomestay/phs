require 'spec_helper'

describe Booking do
	it { should belong_to :booker }
	it { should belong_to :bookee }
	it { should belong_to :enquiry }
	it { should belong_to :homestay }
	it { should have_one :transaction }

	it 'should be valid with valid attributes' do
		booking = FactoryGirl.create :booking
		booking.should be_valid
	end

	describe '#unfinished' do
		subject { Booking.unfinished }
		context 'when there is no unfinished booking' do
			it 'should return []' do
				subject.should be_blank
			end
		end

		context 'when there is an unfinished booking' do
			before { FactoryGirl.create :booking }
			it 'should return unfinished booking' do
				subject.size.should be_eql(1)
			end
		end
	end

	describe '#needing_host_confirmation' do
		subject { Booking.needing_host_confirmation }
		context 'when no booking needed host confirmation' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				subject.should be_blank
			end
		end

		context 'when there is a booking needed host confirmation' do
			before { FactoryGirl.create :booking, owner_accepted: true, response_id: 0 }
			it 'should not return any booking' do
				subject.size.should be_eql(1)
			end
		end
	end

	describe '#declined_by_host' do
		subject { Booking.declined_by_host }
		context 'when no booking declined by host' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				subject.should be_blank
			end
		end

		context 'when there is a booking declined by host' do
			before { FactoryGirl.create :booking, response_id: ReferenceData::Response::UNAVAILABLE.id }
			it 'should not return any booking' do
				subject.size.should be_eql(1)
			end
		end
	end

	describe '#required_response' do
		subject { Booking.required_response }
		context 'when no host requires owner to answer his question' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				subject.any?.should be_false
			end
		end

		context 'when host wants owner to answer his question' do
			before { FactoryGirl.create :booking, response_id: ReferenceData::Response::QUESTION.id }
			it 'should return booking' do
				subject.any?.should be_true
			end
		end
	end

	describe '#accepted_by_host' do
		subject { Booking.accepted_by_host }
		context 'when no host accepts booking' do
			before { FactoryGirl.create :booking }
			it 'should not return any booking' do
				subject.any?.should be_false
			end
		end

		context 'when host accepts booking' do
			before { FactoryGirl.create :booking, response_id: ReferenceData::Response::AVAILABLE.id, host_accepted: true }
			it 'should return booking' do
				subject.any?.should be_true
			end
		end
	end
end