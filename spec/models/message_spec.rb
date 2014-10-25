require 'spec_helper'

describe Message, :type => :model do
	it { is_expected.to belong_to :mailbox }
	it { is_expected.to belong_to :user }

	describe '#to_user' do
		subject { message.to_user }
		let(:user) { FactoryGirl.create :user }
		let(:mailbox) { FactoryGirl.create(:mailbox, guest_mailbox: user) }
		let(:message) { FactoryGirl.create :message, mailbox: mailbox, user: user }

		it 'should return the user to whom this message has been sent' do
			expect(subject).to be_eql(mailbox.host_mailbox)
		end
	end
end