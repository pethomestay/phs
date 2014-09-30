require 'spec_helper'

describe Admin::PetsController do
  before do
    controller.stub(:authenticate_user!).and_return true
    controller.stub(:require_admin!).and_return true
  end

  def valid_attributes
    { name: Faker::Name.first_name,
      date_of_birth: Time.zone.now - 18.years,
      emergency_contact_name: Faker::Name.first_name,
      emergency_contact_phone: '12345678',
      pet_type_id: ReferenceData::PetType::DOG.id,
      size_id: ReferenceData::Size::SMALL.id,
      sex_id: ReferenceData::Sex::MALE_DESEXED.id
    }
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all pets as @pets" do
      p1 = FactoryGirl.create :pet
      p2 = FactoryGirl.create :pet
      p3 = FactoryGirl.create :pet
      get :index, {}, valid_session
      assigns(:pets).should eq [p3, p2, p1]
    end
  end

  describe "GET show" do
    it "assigns the requested pet as @pet" do
      pet = Pet.create! valid_attributes
      get :show, {:id => pet.to_param}, valid_session
      assigns(:pet).should eq(pet)
    end
  end

  describe "GET new" do
    it "assigns a new pet as @pet" do
      get :new, {}, valid_session
      assigns(:pet).should be_a_new(Pet)
    end
  end

  describe "GET edit" do
    it "assigns the requested pet as @pet" do
      pet = Pet.create! valid_attributes
      get :edit, {:id => pet.to_param}, valid_session
      assigns(:pet).should eq(pet)
    end
  end

  describe "POST create" do
    context "with valid params" do
      subject { post :create, {:pet => valid_attributes}, valid_session }
      it "creates a new Pet" do
        expect { subject }.to change(Pet, :count).by(1)
      end

      it "assigns a newly created pet as @pet" do
        subject
        assigns(:pet).should be_a(Pet)
        assigns(:pet).should be_persisted
      end

      it "redirects to the created pet" do
        post :create, {:pet => valid_attributes}, valid_session
        response.should redirect_to(admin_pet_path(Pet.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved pet as @pet" do
        post :create, {:pet => {  }}, valid_session
        assigns(:pet).should be_a_new(Pet)
      end

      it "re-renders the 'new' template" do
        post :create, {:pet => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:pet) { Pet.create! valid_attributes }
    describe "with valid params" do
      subject { put :update, {:id => pet.to_param, :pet => valid_attributes}, valid_session }
      it "updates the requested pet" do
        Pet.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => pet.to_param, :pet => { "these" => "params" }}, valid_session
      end

      it "assigns the requested pet as @pet" do
        subject
        assigns(:pet).should eq(pet)
      end

      it "redirects to the pet" do
        subject
        response.should redirect_to(admin_pet_path(pet))
      end
    end

    describe "with invalid params" do
      it "assigns the pet as @pet" do
        put :update, {:id => pet.to_param, :pet => {name: '' }}, valid_session
        assigns(:pet).should eq(pet)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => pet.to_param, :pet => { name: '' }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, {:id => pet.to_param}, valid_session }
    let!(:pet) { Pet.create! valid_attributes }
    it "destroys the requested pet" do
      expect { subject }.to change(Pet, :count).by(-1)
    end

    it "redirects to the pets list" do
      subject
      response.should redirect_to(admin_pets_url)
    end
  end

end
