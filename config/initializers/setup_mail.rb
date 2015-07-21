#if Rails.env.development?
#	ActionMailer::Base.smtp_settings ={
#		:address              => 'smtp.mailgun.org', # 'smtp.gmail.com' 'smtp.mailgun.org'
#		:port                 => 587,
#		:domain               => 'http://localhost:3000',
#		:user_name            => 'postmaster@sandbox76914.mailgun.org', # 'mehreen.saed@gmail.com' 'postmaster@sandbox76914.mailgun.org'
#		:password             => '4y3cutwhfx23', # 'caaplrpw' '4y3cutwhfx23'
#		:authentication       => 'plain',
#		:enable_starttls_auto => true
#	}

#	ActionMailer::Base.default_url_options[:host] = 'localhost:3000'
#	Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
#end



ActionMailer::Base.delivery_method = :smtp

		ActionMailer::Base.smtp_settings = {
		:address => "smtp.mandrillapp.com",
		:port => 587,
		:user_name => "tom@pethomestay.com",
		:password => ENV["MANDRILL_APIKEY"],
		#:domain    => 'www.pethomestay.com',
		:authentication => "login",
		:enable_starttls_auto => true
		}
	
ActionMailer::Base.default_url_options[:host] = 'localhost:3000'
ActionMailer::Base.default charset: "utf-8"

	