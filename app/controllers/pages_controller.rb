class PagesController < ApplicationController
  before_filter :authenticate_user!, only: [:welcome]
  before_filter :authenticate

  def home
		@homepage = true
  end

  def welcome
    @welcome = true
  end

  def why_join_pethomestay
  end

  def how_does_it_work
  end

  def about_us
  end

  def faqs
  end

  def house_rules
  end

  def privacy_policy
  end

  def terms_and_conditions
  end

  def post_to_securepay
  end

  protected
  def authenticate
    if  ENV['GOOGLE_ANALYTICS_TRACKING_ID'] == "UA-32892865-1" #we are in a prod env
      return true
    else
      authenticate_or_request_with_http_basic do | username, password |
        username == ENV['HTTP_USERNAME'] and password == ENV['HTTP_PASSWORD']
      end
    end
  end
end
