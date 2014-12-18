class AddOptOutSmsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :opt_out_sms, :boolean, default: false
  end
end
