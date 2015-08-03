	
ActionMailer::Base.delivery_method = :smtp		
ActionMailer::Base.smtp_settings = {		
	:address => "smtp.mandrillapp.com",		
	:port => 587,		
	:user_name => "tom@pethomestay.com",		
	:password => ENV["MANDRILL_APIKEY"],		
	:domain    => 'www.pethomestay.com.au',		
	#:domain => 'http://localhost:3000',		
	:authentication => "login",		
	:enable_starttls_auto => true		
}		
		
ActionMailer::Base.default_url_options[:host] = 'www.pethomestay.com.au'		
ActionMailer::Base.default charset: "utf-8"		
