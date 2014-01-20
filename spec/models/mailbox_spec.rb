require 'spec_helper'

describe Mailbox do
	it { should belong_to :guest_mailbox }
	it { should belong_to :host_mailbox }
	it { should belong_to :enquiry }
	it { should belong_to :booking }
	it { should have_many :messages }

	it { should validate_presence_of :guest_mailbox_id }
	it { should validate_presence_of :host_mailbox_id }

	describe '#enquiry_or_booking_presence' do
		subject { mailbox.valid? }

		context 'with no enquiry and booking' do
			let(:mailbox)  { FactoryGirl.build :mailbox, enquiry: nil, booking: nil }

			it 'should be false' do
				subject.should be_false
			end
		end

		context 'with enquiry or booking' do
			let(:mailbox)  { FactoryGirl.create :mailbox }

		  it 'should be true' do
			  subject.should be_true
		  end
		end
	end

	describe '#subject_message' do
		subject { mailbox.subject_message }

		context 'when mailbox has enquiry' do
			let(:mailbox)  { FactoryGirl.create :mailbox }

			it 'should return enquiry subject message' do
				subject.should be_eql(mailbox.enquiry_subject_message)
			end
		end

		context 'when mailbox has booking' do
			let(:mailbox)  { FactoryGirl.create :mailbox }
			before {
				mailbox.enquiry = nil
				mailbox.booking = FactoryGirl.create(:booking)
			}

			it 'should return booking subject message' do
			  subject.should be_eql(mailbox.booking_subject_message)
			end
		end
	end

	describe '#subject_dates' do
		subject { mailbox.subject_dates }
		let(:mailbox)  { FactoryGirl.create :mailbox }

		context 'when check-in and check-out dates are present' do
			it 'should return dates message' do
				subject.should be_eql(mailbox.dates_message)
			end
		end

		context 'when check-in or check-out dates are absent' do
			before { mailbox.enquiry.check_in_date = nil }

			it 'should return absent date message' do
				subject.should be_eql(mailbox.absent_dates_message)
			end
		end
	end
end