class RemoveBankFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :bank
  end

  def down
    add_column :accounts, :bank, :string
  end
end
