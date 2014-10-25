require 'spec_helper'

describe "admin/users/show", :type => :view do
  before(:each) do
    @user = assign(:user, stub_model(User, created_at: DateTime.now, date_of_birth: DateTime.new(1900, 1,1)))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
