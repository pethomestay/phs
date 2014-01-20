class CreateAccounts < ActiveRecord::Migration
  def up
		create_table :accounts do |t|
			t.belongs_to :user
			t.string :name
			t.string :bank
			t.string :bsb
			t.string :account_number

			t.timestamps
		end
  end

  def down
		drop_table :accounts
  end
end
