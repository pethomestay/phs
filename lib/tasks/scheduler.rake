desc 'This task is called by the Heroku scheduler add-on'
task :send_enquiry_first_sms_reminder => :environment do
  Enquiry.where(created_at: 1.days.ago..8.hours.ago).where(send_first_sms_reminder_at: nil).each { |enquiry|
    next if enquiry.replied_by_host?
    enquiry.send_first_sms_reminder unless enquiry.replied_by_host?
  }
end

task :send_enquiry_second_sms_reminder => :environment do
  Enquiry.where(created_at: 1.days.ago..16.hours.ago).where(send_second_sms_reminder_at: nil).each { |enquiry|
    next if enquiry.replied_by_host?
    enquiry.send_second_sms_reminder unless enquiry.replied_by_host?
  }
end
