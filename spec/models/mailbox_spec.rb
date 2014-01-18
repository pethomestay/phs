require 'spec_helper'

describe Mailbox do
	it { should belong_to :guest_mailbox }
	it { should belong_to :host_mailbox }
	it { should belong_to :enquiry }
	it { should belong_to :booking }
	it { should have_many :messages }

	it { should validate_presence_of :guest_mailbox_id }
	it { should validate_presence_of :host_mailbox_id }
end