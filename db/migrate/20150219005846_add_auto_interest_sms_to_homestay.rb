class AddAutoInterestSmsToHomestay < ActiveRecord::Migration
  def change
    add_column :homestays, :auto_interest_sms, :text
  end
end
