class PagesController < ApplicationController
  before_filter :authenticate_user!, only: [:welcome]
  before_filter :protect_in_production, only: [:new_home]

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

  def new_home
    render layout: "new_application"
  end

  protected
  def protect_in_production
    if  ENV['RAILS_ENV'] == "production"
      authenticate_or_request_with_http_basic do | username, password |
        username == ENV['MY_STAGING_USERNAME'] and password == ENV['MY_STAGING_PASSWORD']
      end
    else
      true
    end
  end
end
