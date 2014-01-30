require 'spec_helper'

describe Message do
	it { should belong_to :mailbox }
	it { should belong_to :user }

	describe '#to_user' do
		subject { message.to_user }
		let(:user) { FactoryGirl.create :user }
		let(:mailbox) { FactoryGirl.create(:mailbox, guest_mailbox: user) }
		let(:message) { FactoryGirl.create :message, mailbox: mailbox, user: user }

		it 'should return the user to whom this message has been sent' do
			subject.should be_eql(mailbox.host_mailbox)
		end
	end
end