

describe "admin/enquiries/edit", :type => :view do
  before(:each) do
    @enquiry = FactoryGirl.create :enquiry
  end

  it "renders the edit admin_enquiry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_enquiries_path(@enquiry), :method => "post" do
    end
  end
end
