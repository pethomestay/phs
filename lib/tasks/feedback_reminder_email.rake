desc "This task sends feedback reminders to those who need them"
task :send_feedback_reminder_emails => :environment do
    puts "Beginning to send feedback reminder emails"

    Enquiry.owner_accepted.need_feedback.unsent_feedback_email.each do |enquiry|
      unless enquiry.feedback_for_owner
        UserMailer.leave_feedback(enquiry.homestay.user, enquiry.user, enquiry).deliver
      end

      unless enquiry.feedback_for_homestay
        UserMailer.leave_feedback(enquiry.user, enquiry.homestay.user, enquiry).deliver
      end

      enquiry.update_attribute :sent_feedback_email, true
    end

    puts "Finished."
end
