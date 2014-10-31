class AddSendSmsReminderAtToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :send_first_sms_reminder_at, :datetime
    add_column :enquiries, :send_second_sms_reminder_at, :datetime
  end
end
