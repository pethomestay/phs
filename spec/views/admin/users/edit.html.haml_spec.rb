require 'spec_helper'

describe "admin/users/edit", :type => :view do
  before(:each) do
	  @user = FactoryGirl.create :user
  end

  it "renders the edit admin_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_users_path(@user), :method => "post" do
    end
  end
end
