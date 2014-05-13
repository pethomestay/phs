desc "if a mobile_number field is blank set it to n/a for existing users"
task :mobile_number_fix => :environment do
    #lets use each to ensure  each user in the db has a mobile number value
    User.all.each{ | u |
      if u.mobile_number.blank? #either nil or ''
        u.mobile_number = "n/a"
        u.save!
      end
    }
end