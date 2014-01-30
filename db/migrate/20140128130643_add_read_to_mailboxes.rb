class AddReadToMailboxes < ActiveRecord::Migration
  def up
		add_column :mailboxes, :host_read, :boolean, default: false
		add_column :mailboxes, :guest_read, :boolean, default: false
  end

	def down
		drop_table :mailboxes, :host_read
		drop_table :mailboxes, :guest_read
	end
end
