

describe "admin/pets/edit", :type => :view do
  before(:each) do
    @pet = FactoryGirl.create :pet
  end

  it "renders the edit admin_pet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_pets_path(@pet), :method => "post" do
    end
  end
end
