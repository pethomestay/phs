require 'spec_helper'

feature 'User signs up', focus: true do
  scenario 'with correct email and password' do
    visit new_user_registration_path
    within 'form' do
      fill_in 'user[first_name]', with: Faker::Name.first_name
      fill_in 'user[last_name]', with: Faker::Name.last_name
      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[mobile_number]', with: '0455555555'
      fill_in 'user[password]', with: 'sd2864925'
    end

    expect { click_button 'Sign Up' }.to change { ActionMailer::Base.deliveries.count }.by 1
  end
end
