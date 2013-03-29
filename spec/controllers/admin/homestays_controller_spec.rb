require 'spec_helper'

describe Admin::HomestaysController do
  let(:user) { User.make }
  before do
    controller.stub(:authenticate_user!).and_return true
    controller.stub(:require_admin!).and_return true
    Homestay.any_instance.stub(:geocode).and_return true
  end

  def valid_attributes(override_or_add={})
    { cost_per_night: 20.00,
      address_1: '1 Spring street',
      address_suburb: 'Melbourne',
      address_city: 'Melbourne',
      address_country: 'AU',
      title: 'my little homestay',
      description: Faker::Lorem.paragraph,
      property_type_id: ReferenceData::PropertyType::HOUSE.id,
      outdoor_area_id: ReferenceData::OutdoorArea::MEDIUM.id
    }.merge(override_or_add)
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all homestays as @homestays" do
      Homestay.stub(:all).and_return 'all homestays'
      get :index, {}, valid_session
      assigns(:homestays).should eq('all homestays')
    end
  end

  describe "GET show" do
    it "assigns the requested homestay as @homestay" do
      homestay = Homestay.create! valid_attributes(user:user)
      get :show, {:id => homestay.to_param}, valid_session
      assigns(:homestay).should eq(homestay)
    end
  end

  describe "GET edit" do
    it "assigns the requested homestay as @homestay" do
      homestay = Homestay.create! valid_attributes(user:user)
      get :edit, {:id => homestay.to_param}, valid_session
      assigns(:homestay).should eq(homestay)
    end
  end

  describe "PUT update" do
    let(:homestay) { Homestay.create! valid_attributes(user:user) }
    describe "with valid params" do
      subject { put :update, {:id => homestay.to_param, :homestay => valid_attributes}, valid_session }
      it "updates the requested homestay" do
        Homestay.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => homestay.to_param, :homestay => { "these" => "params" }}, valid_session
      end

      it "assigns the requested homestay as @homestay" do
        subject
        assigns(:homestay).should eq(homestay)
      end

      it "redirects to the homestay" do
        subject
        response.should redirect_to(admin_homestay_path(homestay))
      end
    end

    describe "with invalid params" do
      it "assigns the homestay as @homestay" do
        put :update, {:id => homestay.to_param, :homestay => {title: '' }}, valid_session
        assigns(:homestay).should eq(homestay)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => homestay.to_param, :homestay => { title: '' }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, {:id => homestay.to_param}, valid_session }
    let!(:homestay) { Homestay.create! valid_attributes(user:user) }
    it "destroys the requested homestay" do
      expect { subject }.to change(Homestay, :count).by(-1)
    end

    it "redirects to the homestays list" do
      subject
      response.should redirect_to(admin_homestays_url)
    end
  end

end
