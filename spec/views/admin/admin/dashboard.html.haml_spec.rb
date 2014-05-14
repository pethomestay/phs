require 'spec_helper'

describe 'admin/admin/dashboard' do
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
    rendered.should have_selector(:tr) do |content|
      content.should have_selector(:td, content: 'User Count')
      content.should have_selector(:td, content: "#{stats[:user_count]}")
    end
  end

  it 'should display stats for the homestay count' do
    rendered.should have_selector(:tr) do |content|
      content.should have_selector(:td, content: 'Homestay Count')
      content.should have_selector(:td, content: "#{stats[:homestay_count]}")
    end
  end

  it 'should display stats for the pet count' do
    rendered.should have_selector(:tr) do |content|
      content.should have_selector(:td, content: 'Pet Count')
      content.should have_selector(:td, content: "#{stats[:pet_count]}")
    end
  end

  it 'should display stats for the enquiry count' do
    rendered.should have_selector(:tr) do |content|
      content.should have_selector(:td, content: 'Enquiries Count')
      content.should have_selector(:td, content: "#{stats[:enquiry_count]}")
    end
  end

  it 'should have a table for showing the recent signups' do
    rendered.should have_selector('table caption', content: 'Recent Signups')
  end

  it 'should have a table for showing the recent homestays' do
    rendered.should have_selector('table caption', content: 'Recent Homestays')
  end

  it 'should have a table for showing the recent enquiries' do
    rendered.should have_selector('table caption', content: 'Recent Enquiries')
  end
end
