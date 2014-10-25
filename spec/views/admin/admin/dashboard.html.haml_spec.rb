require 'spec_helper'

describe 'admin/admin/dashboard', :type => :view do
  let(:stats) { {user_count: 2, homestay_count: 3, pet_count: 4, bookings_count: 2, enquiries_count: 5} }
  let(:homestays) { [] }
  let(:users) { [] }
  let(:enquiries) { [] }
  let(:bookings) { [] }

  before do
    assign(:stats, stats)
    assign(:homestays, homestays)
    assign(:users, users)
    assign(:enquiries, enquiries)
    assign(:bookings, bookings)
    render
  end

  it 'should display stats for the user count' do
    expect(rendered).to have_selector('tr td', text: 'User Count')
    expect(rendered).to have_selector('tr td', text: "#{stats[:user_count]}")
  end

  it 'should display stats for the homestay count' do
    expect(rendered).to have_selector('tr td', text: 'Homestay Count')
    expect(rendered).to have_selector('tr td', text: "#{stats[:homestay_count]}")
  end

  it 'should display stats for the pet count' do
    expect(rendered).to have_selector('tr td', text: 'Pet Count')
    expect(rendered).to have_selector('tr td', text: "#{stats[:pet_count]}")
  end

  it 'should display stats for the enquiry count' do
    expect(rendered).to have_selector('tr td', text: 'Enquiries Count')
    expect(rendered).to have_selector('tr td', text: "#{stats[:enquiry_count]}")
  end

  it 'should have a table for showing the recent signups' do
    expect(rendered).to have_selector('table caption', text: 'Recent Signups')
  end

  it 'should have a table for showing the recent homestays' do
    expect(rendered).to have_selector('table caption', text: 'Recent Homestays')
  end

  it 'should have a table for showing the recent enquiries' do
    expect(rendered).to have_selector('table caption', text: 'Recent Enquiries')
  end
end
