require 'spec_helper'

describe Admin::EnquiriesController do
  let!(:homestay) { Homestay.make! }
  let!(:user) { User.make! }

  def valid_attributes
    { homestay_id: homestay.id,
      user_id: user.id,
      duration_id: ReferenceData::Duration::OVERNIGHT.id,
      date: Time.zone.now
    }
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all enquiries as @enquiries" do
      enquiry = Enquiry.create! valid_attributes
      get :index, {}, valid_session
      assigns(:enquiries).should eq([enquiry])
    end
  end

  describe "GET show" do
    it "assigns the requested enquiry as @enquiry" do
      enquiry = Enquiry.create! valid_attributes
      get :show, {:id => enquiry.to_param}, valid_session
      assigns(:enquiry).should eq(enquiry)
    end
  end

  describe "GET new" do
    it "assigns a new enquiry as @enquiry" do
      get :new, {}, valid_session
      assigns(:enquiry).should be_a_new(Enquiry)
    end
  end

  describe "GET edit" do
    it "assigns the requested enquiry as @enquiry" do
      enquiry = Enquiry.create! valid_attributes
      get :edit, {:id => enquiry.to_param}, valid_session
      assigns(:enquiry).should eq(enquiry)
    end
  end

  describe "POST create" do
    context "with valid params" do
      subject { post :create, {:enquiry => valid_attributes}, valid_session }
      it "creates a new Enquiry" do
        expect { subject }.to change(Enquiry, :count).by(1)
      end

      it "assigns a newly created enquiry as @enquiry" do
        subject
        assigns(:enquiry).should be_a(Enquiry)
        assigns(:enquiry).should be_persisted
      end

      it "redirects to the created enquiry" do
        post :create, {:enquiry => valid_attributes}, valid_session
        response.should redirect_to(admin_enquiry_path(Enquiry.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved enquiry as @enquiry" do
        post :create, {:enquiry => {  }}, valid_session
        assigns(:enquiry).should be_a_new(Enquiry)
      end

      it "re-renders the 'new' template" do
        post :create, {:enquiry => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:enquiry) { Enquiry.create! valid_attributes }
    describe "with valid params" do
      subject { put :update, {:id => enquiry.to_param, :enquiry => valid_attributes}, valid_session }
      it "updates the requested enquiry" do
        Enquiry.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => enquiry.to_param, :enquiry => { "these" => "params" }}, valid_session
      end

      it "assigns the requested enquiry as @enquiry" do
        subject
        assigns(:enquiry).should eq(enquiry)
      end

      it "redirects to the enquiry" do
        subject
        response.should redirect_to(admin_enquiry_path(enquiry))
      end
    end

    describe "with invalid params" do
      it "assigns the enquiry as @enquiry" do
        put :update, {:id => enquiry.to_param, :enquiry => {duration_id: '' }}, valid_session
        assigns(:enquiry).should eq(enquiry)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => enquiry.to_param, :enquiry => { duration_id: '' }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, {:id => enquiry.to_param}, valid_session }
    let!(:enquiry) { Enquiry.create! valid_attributes }
    it "destroys the requested enquiry" do
      expect { subject }.to change(Enquiry, :count).by(-1)
    end

    it "redirects to the enquiries list" do
      subject
      response.should redirect_to(admin_enquiries_url)
    end
  end

end
