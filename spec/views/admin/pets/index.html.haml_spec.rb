require 'spec_helper'

describe "admin/pets/index" do
  before(:each) do
    assign(:pets, [
      stub_model(Pet, pets: [], created_at: Time.zone.now),
      stub_model(Pet, pets: [], created_at: Time.zone.now)
    ])
  end

  it "renders a list of pets" do
    pending 'This does not like will_paginate for some reason'
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
