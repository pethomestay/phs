class PagesController < ApplicationController
  before_filter :authenticate_user!, only: [:welcome]
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
end
