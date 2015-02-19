class AddAutoDeclineSmsToHomestay < ActiveRecord::Migration
  def change
    add_column :homestays, :auto_decline_sms, :text
  end
end
