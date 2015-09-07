desc "sanitise email addresses and passwords in local database"
task :sanitise => :environment do
  # moved back to rake task since it's only used here and not needed by user
  sanitise_user = lambda do |user|
    clean_email = user.email
    if clean_email.include? "<" #in the form of Joe Blogs <joe.blogs@company.com>
      start_str = "<"
      end_str = ">"
      clean_email = clean_email[/#{start_str}(.*?)#{end_str}/m, 1] #extract out the email part
    end
    #new_email = "darmou+#{clean_email.split("@").first}_#{user.id.to_s}@tapmint.com" #
    new_email = "xuebing@pethomestay.com"
    user.email = new_email
    user.password = "password"
    user.password_confirmation = "password"
    user.save!
    user.confirm!
    user.save!
  end

  #check to ensure we are using the local enviroment
  if ENV.has_key?("SAFE_TO_SANITISE") and ActiveRecord::ConnectionAdapters::Column.value_to_boolean(ENV['SAFE_TO_SANITISE'])
    puts "Turning off email sending"
    #Ensure that email sending is switched off
    dm = ActionMailer::Base.delivery_method    #save the original setting for later on
    ActionMailer::Base.delivery_method = :test #turn off sending email
    #lets use each to sanitise each user in the db
    #so lets say their email was joe.blogs@company.com and their id was 33
    #new email is joe.blogs_33@tapmint.com and password is password
    puts "Sanitising email addresses and passwords"
    User.all.each{ | u |
      if u.mobile_number.blank? #just in case we have a blank mobile record
        u.mobile_number = "n/a"
      end
      sanitise_user.call(u)  #so we can unit test lets add a method that can be run for each user sanitise their email address
    }
    puts "Resetting email sending back to origional value"
    ActionMailer::Base.delivery_method = dm #turn sending back to original state
  else
    puts "Rake task needs to be executed in the local enviroment, is this is being run from a dev enviroment and ENV['SAFE_TO_SANITISE']=='true'?"
  end
end
