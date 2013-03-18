require './app/models/search'

class PagesController < ApplicationController

  def home
  end

  def welcome
    unless current_user
      redirect_to root_path
      return
    end
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
end
