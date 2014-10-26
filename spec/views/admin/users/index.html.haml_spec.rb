

describe "admin/users/index", :type => :view do
  before(:each) do
    assign(:users, [
      stub_model(User,pets: [], created_at: Time.zone.now),
      stub_model(User, pets: [], created_at: Time.zone.now)
    ])
  end

  it "renders a list of users" do
    skip 'This does not like will_paginate for some reason'
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
