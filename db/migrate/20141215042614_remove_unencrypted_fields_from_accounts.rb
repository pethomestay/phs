class RemoveUnencryptedFieldsFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :bsb
    remove_column :accounts, :name
    remove_column :accounts, :account_number
  end

  def down
    add_column :accounts, :account_number, :string
    add_column :accounts, :name, :string
    add_column :accounts, :bsb, :string
  end
end
