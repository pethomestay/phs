require 'spec_helper'

describe "admin/pets/show" do
  before(:each) do
    @pet = FactoryGirl.create :pet
    @pet.user = FactoryGirl.create :user
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
