options = {
  forward_emails_to: 'dave@pethomestay.com',
  deliver_emails_to: ['@pethomestay.com']
}

interceptor = MailInterceptor::Interceptor.new(options)

unless (Rails.env.test? || Rails.env.production?)
  ActionMailer::Base.register_interceptor(interceptor)
end
