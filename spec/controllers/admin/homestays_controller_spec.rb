require 'spec_helper'

describe Admin::HomestaysController, :type => :controller do
  let(:user) { FactoryGirl.create :user }
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    allow(controller).to receive(:require_admin!).and_return true
    allow_any_instance_of(Homestay).to receive(:geocode).and_return true
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
      h1 = FactoryGirl.create :homestay
      h2 = FactoryGirl.create :homestay
      h3 = FactoryGirl.create :homestay
      get :index, {}, valid_session
      expect(assigns(:homestays)).to eq [h3, h2, h1]
    end
  end

  describe "GET show" do
    it "assigns the requested homestay as @homestay" do
      homestay = Homestay.create! valid_attributes
      get :show, {:id => homestay.to_param}, valid_session
      expect(assigns(:homestay)).to eq(homestay)
    end
  end

  describe "GET edit" do
    it "assigns the requested homestay as @homestay" do
      homestay = Homestay.create! valid_attributes
      get :edit, {:id => homestay.to_param}, valid_session
      expect(assigns(:homestay)).to eq(homestay)
    end
  end

  describe "PUT update" do
    let(:homestay) { Homestay.create! valid_attributes }
    describe "with valid params" do
      subject { put :update, {:id => homestay.to_param, :homestay => valid_attributes}, valid_session }
      it "updates the requested homestay" do
        expect_any_instance_of(Homestay).to receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => homestay.to_param, :homestay => { "these" => "params" }}, valid_session
      end

      it "assigns the requested homestay as @homestay" do
        subject
        expect(assigns(:homestay)).to eq(homestay)
      end

      it "redirects to the homestay" do
        subject
        expect(response).to redirect_to(admin_homestay_path(homestay))
      end
    end

    describe "with invalid params" do
      it "assigns the homestay as @homestay" do
        put :update, {:id => homestay.to_param, :homestay => {title: '' }}, valid_session
        expect(assigns(:homestay)).to eq(homestay)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => homestay.to_param, :homestay => { title: '' }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, {:id => homestay.to_param}, valid_session }
    let!(:homestay) { Homestay.create! valid_attributes }
    it "destroys the requested homestay" do
      expect { subject }.to change(Homestay, :count).by(-1)
    end

    it "redirects to the homestays list" do
      subject
      expect(response).to redirect_to(admin_homestays_url)
    end
  end

end
