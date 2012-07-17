class AddPhoneNumbersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :mobile_number, :string
  end
end
