require 'spec_helper'

describe "admin/pets/show", :type => :view do
  before(:each) do
    #@user = assign(:pet, stub_model(Pet))
	  @pet = FactoryGirl.create :pet
	  @pet.user = FactoryGirl.create :user
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
