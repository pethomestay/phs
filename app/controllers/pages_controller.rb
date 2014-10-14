class PagesController < ApplicationController
  before_filter :authenticate_user!, only: [:welcome]

  def home
    @homepage = true
    render layout: 'new_application'
  end

  def welcome
    @welcome = true
  end

  def why_join_pethomestay
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
  end
end
