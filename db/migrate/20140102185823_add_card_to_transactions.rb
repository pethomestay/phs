class AddCardToTransactions < ActiveRecord::Migration
  def up
		add_column :transactions, :card_id, :integer
  end

	def down
		remove_column :transactions, :card_id
	end
end
