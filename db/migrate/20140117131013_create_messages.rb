class CreateMessages < ActiveRecord::Migration
  def up
	  create_table :messages do |t|
		  t.belongs_to :mailbox
		  t.belongs_to :user
		  t.text :message_text

		  t.timestamps
	  end
  end

  def down
	  drop_table :messages
  end
end
