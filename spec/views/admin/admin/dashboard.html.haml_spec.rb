require 'spec_helper'

describe 'admin/admin/dashboard' do
  let(:stats) { {user_count: 2, homestay_count: 3, pet_count: 4} }
  let(:homestays) { [] }
  let(:users) { [] }

  before do
    assign(:stats, stats)
    assign(:homestays, homestays)
    assign(:users, users)
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

  it 'should have a table for showing the recent signups' do
    rendered.should have_selector('table caption', content: 'Recent Signups')
  end

  it 'should have a table for showing the recent homestays' do
    rendered.should have_selector('table caption', content: 'Recent Homestays')
  end
end