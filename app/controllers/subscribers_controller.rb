class SubscribersController < ApplicationController
  def create
    begin
      gibbon = Gibbon::API.new(ENV['MAILCHIMP_API_KEY'])
      gibbon.lists.subscribe({id: ENV['MAILCHIMP_LIST_ID'], email: {email: params[:email]}})
      render json: {ok: true}
    rescue Gibbon::MailChimpError => e
      render json: {ok: false, msg: e.message}
    end
  end
end
