class PagesController < ApplicationController
  before_filter :authenticate_user!, only: [:welcome]

  def home
    @homepage = true
    render layout: 'new_application'
  end

  def welcome
    render layout: 'new_application'
  end

  def why_join_pethomestay
    render layout: 'new_application'
  end

  def about_us
    render layout: 'new_application'
  end

  def the_team
  end

  def house_rules
  end

  def post_to_securepay
  end

  def investors
  end

  def jobs
  end

  def partners
    @contact = Contact.new
  end

  def in_the_press
    render layout: 'new_application'
  end
end
