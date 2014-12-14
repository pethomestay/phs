class AddEncryptedFieldsToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :encrypted_name, :string
    add_column :accounts, :encrypted_bsb, :string
    add_column :accounts, :encrypted_account_number, :string
  end
end
