require 'spec_helper'

feature 'User signs in', focus: true do
  scenario 'with correct email and password' do
    sign_in

    expect(page).to have_content 'My Account'
  end

  def sign_in
    user = FactoryGirl.create :confirmed_user
    visit new_user_session_path
    within 'form' do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
    end
    click_button 'Log In'
  end
end
