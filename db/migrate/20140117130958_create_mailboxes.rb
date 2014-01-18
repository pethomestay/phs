class CreateMailboxes < ActiveRecord::Migration
  def up
	  create_table :mailboxes do |t|
		  t.integer :host_mailbox_id
		  t.integer :guest_mailbox_id
		  t.belongs_to :enquiry
		  t.belongs_to :booking

		  t.timestamps
	  end
  end

  def down
		drop_table :mailboxes
  end
end
