require 'spec_helper'

describe "admin/pets/show" do
  before(:each) do
    @user = assign(:pet, stub_model(Pet))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
