if Rails.env.development?
	ActionMailer::Base.smtp_settings ={
		:address              => 'smtp.mailgun.org', # 'smtp.gmail.com' 'smtp.mailgun.org'
		:port                 => 587,
		:domain               => 'http://localhost:3000',
		:user_name            => 'postmaster@sandbox76914.mailgun.org', # 'mehreen.saed@gmail.com' 'postmaster@sandbox76914.mailgun.org'
		:password             => '4y3cutwhfx23', # 'caaplrpw' '4y3cutwhfx23'
		:authentication       => 'plain',
		:enable_starttls_auto => true
	}

	ActionMailer::Base.default_url_options[:host] = 'localhost:3000'
	Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
end