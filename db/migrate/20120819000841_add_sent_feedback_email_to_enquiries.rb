class AddSentFeedbackEmailToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :sent_feedback_email, :boolean, default: false
  end
end
