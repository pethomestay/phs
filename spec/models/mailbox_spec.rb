

describe Mailbox, :type => :model do
	it { is_expected.to belong_to :guest_mailbox }
	it { is_expected.to belong_to :host_mailbox }
	it { is_expected.to belong_to :enquiry }
	it { is_expected.to belong_to :booking }
	it { is_expected.to have_many :messages }

	it { is_expected.to validate_presence_of :guest_mailbox_id }
	it { is_expected.to validate_presence_of :host_mailbox_id }

	describe '#enquiry_or_booking_presence' do
		subject { mailbox.valid? }

		context 'with no enquiry and booking' do
			let(:mailbox)  { FactoryGirl.build :mailbox, enquiry: nil, booking: nil }

			it 'should be false' do
				expect(subject).to be_falsey
			end
		end

		context 'with enquiry or booking' do
			let(:mailbox)  { FactoryGirl.create :mailbox }

		  it 'should be true' do
			  expect(subject).to be_truthy
		  end
		end
	end

	describe '#subject_message' do
		subject { mailbox.subject_message }

		context 'when mailbox has enquiry' do
			let(:mailbox)  { FactoryGirl.create :mailbox }

			it 'should return enquiry subject message' do
				expect(subject).to be_eql(mailbox.subject_message)
			end
		end

		context 'when mailbox has booking' do
			let(:mailbox)  { FactoryGirl.create :mailbox }
			before {
				mailbox.enquiry = nil
				mailbox.booking = FactoryGirl.create(:booking)
			}

			it 'should return booking subject message' do
			  expect(subject).to be_eql(mailbox.booking_subject_message)
			end
		end
	end

	describe '#subject_dates' do
		subject { mailbox.subject_dates }
		let(:mailbox)  { FactoryGirl.create :mailbox }

		context 'when check-in and check-out dates are present' do
			it 'should return dates message' do
				expect(subject).to be_eql(mailbox.dates_message)
			end
		end

		context 'when check-in or check-out dates are absent' do
			before { mailbox.enquiry.check_in_date = nil }

			it 'should return absent date message' do
				expect(subject).to be_eql(mailbox.absent_dates_message)
			end
		end
	end

	describe '#read_by?' do
		subject { mailbox }
		let(:mailbox)  { FactoryGirl.create :mailbox }

		context 'if guest has read the inbox' do
			before { mailbox.guest_read = true }

			it 'should return false' do
				expect(subject.read_by?(mailbox.guest_mailbox)).to be_eql(true)
			end
		end

		context 'if guest has not read the inbox' do
			before { mailbox.guest_read = false }

			it 'should return false' do
				expect(subject.read_by?(mailbox.guest_mailbox)).to be_eql(false)
			end
		end

		context 'if host has read the inbox' do
			before { mailbox.host_read = true }

			it 'should return false' do
				expect(subject.read_by?(mailbox.host_mailbox)).to be_eql(true)
			end
		end

		context 'if guest has not read the inbox' do
			before { mailbox.host_read = false }

			it 'should return false' do
				expect(subject.read_by?(mailbox.host_mailbox)).to be_eql(false)
			end
		end
	end

	describe '#read_by' do
		subject { mailbox }
		let(:mailbox)  { FactoryGirl.create :mailbox }

		context 'when host read the mailbox' do
			before { mailbox.read_by(mailbox.host_mailbox) }

			it 'should set host_read to true' do
				expect(subject.host_read).to be_truthy
			end
		end

		context 'when guest read the mailbox' do
			before { mailbox.read_by(mailbox.guest_mailbox) }

			it 'should set host_read to true' do
				expect(subject.guest_read).to be_truthy
			end
		end
	end

	describe '#read_for' do
		subject { mailbox }
		let(:mailbox)  { FactoryGirl.create :mailbox }

		context 'when guest creates a message' do
			before { mailbox.read_for(mailbox.guest_mailbox) }

			it 'should turn host as unread' do
				expect(subject.host_read).to be_falsey
			end
		end

		context 'when host creates a message' do
			before { mailbox.read_for(mailbox.host_mailbox) }

			it 'should turn guest as unread' do
				expect(subject.guest_read).to be_falsey
			end
		end
	end
end
