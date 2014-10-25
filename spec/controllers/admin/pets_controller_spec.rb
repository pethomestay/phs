require 'spec_helper'

describe Admin::PetsController, :type => :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    allow(controller).to receive(:require_admin!).and_return true
  end

  def pet_attributes
    { name: Faker::Name.first_name,
      pet_age: '18',
      emergency_contact_name: Faker::Name.first_name,
      emergency_contact_phone: '12345678',
      pet_type_id: ReferenceData::PetType::DOG.id,
      size_id: ReferenceData::Size::SMALL.id,
      sex_id: ReferenceData::Sex::MALE_DESEXED.id,
      energy_level: 1,
      personalities: ['happy', 'sad', 'whatever']
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
      expect(assigns(:pets)).to eq [p3, p2, p1]
    end
  end

  describe "GET show" do
    it "assigns the requested pet as @pet" do
      pet = Pet.create! pet_attributes
      get :show, {:id => pet.to_param}, valid_session
      expect(assigns(:pet)).to eq(pet)
    end
  end

  describe "GET new" do
    it "assigns a new pet as @pet" do
      get :new, {}, valid_session
      expect(assigns(:pet)).to be_a_new(Pet)
    end
  end

  describe "GET edit" do
    it "assigns the requested pet as @pet" do
      pet = Pet.create! pet_attributes
      get :edit, {:id => pet.to_param}, valid_session
      expect(assigns(:pet)).to eq(pet)
    end
  end

  describe "POST create" do
    context "with valid params" do
      subject { post :create, {:pet => pet_attributes}, valid_session }
      it "creates a new Pet" do
        expect { subject }.to change(Pet, :count).by(1)
      end

      it "assigns a newly created pet as @pet" do
        subject
        expect(assigns(:pet)).to be_a(Pet)
        expect(assigns(:pet)).to be_persisted
      end

      it "redirects to the created pet" do
        post :create, {:pet => pet_attributes}, valid_session
        expect(response).to redirect_to(admin_pet_path(Pet.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved pet as @pet" do
        post :create, {:pet => {  }}, valid_session
        expect(assigns(:pet)).to be_a_new(Pet)
      end

      it "re-renders the 'new' template" do
        post :create, {:pet => {  }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:pet) { Pet.create! pet_attributes }
    describe "with valid params" do
      subject { put :update, {:id => pet.to_param, :pet => pet_attributes}, valid_session }
      it "updates the requested pet" do
        expect_any_instance_of(Pet).to receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => pet.to_param, :pet => { "these" => "params" }}, valid_session
      end

      it "assigns the requested pet as @pet" do
        subject
        expect(assigns(:pet)).to eq(pet)
      end

      it "redirects to the pet" do
        subject
        expect(response).to redirect_to(admin_pet_path(pet))
      end
    end

    describe "with invalid params" do
      it "assigns the pet as @pet" do
        put :update, {:id => pet.to_param, :pet => {name: '' }}, valid_session
        expect(assigns(:pet)).to eq(pet)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => pet.to_param, :pet => { name: '' }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, {:id => pet.to_param}, valid_session }
    let!(:pet) { Pet.create! pet_attributes }
    it "destroys the requested pet" do
      expect { subject }.to change(Pet, :count).by(-1)
    end

    it "redirects to the pets list" do
      subject
      expect(response).to redirect_to(admin_pets_url)
    end
  end

end
