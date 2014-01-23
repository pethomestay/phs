class AddPayorToUsersAndStorageTextToTransactions < ActiveRecord::Migration
  def up
		add_column :users, :payor, :boolean, default: false
		add_column :transactions, :storage_text, :string
  end

	def down
		remove_column :transactions, :storage_text
		remove_column :users, :payor
	end
end
