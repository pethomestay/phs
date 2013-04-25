require 'spec_helper'

describe PetsController do
  before do
    controller.stub(:authenticate_user!).and_return true
  end

  def valid_attributes(override_or_add={})
    { name: 'fred', date_of_birth: '2012-12-12', emergency_contact_name: 'owner 1',
      emergency_contact_phone: '1234', pet_type_id: '1', size_id: '1', sex_id: '1' }.merge(override_or_add)
  end

  describe 'GET #index' do
    subject { get :index }
    it 'should assigns current_user s pets to the pets variable' do
      controller.stub_chain(:current_user, :pets).and_return 'my pets'
      subject
      assigns(:pets).should == 'my pets'
    end
  end

  describe 'GET #new' do
    subject { get :new }
    before { controller.stub_chain(:current_user, :pets, :build).and_return 'New Pet' }

    it 'should make a new pet object available to views' do
      subject
      assigns(:pet).should == 'New Pet'
    end

    it 'should render the new template' do
      subject
      response.should render_template :new
    end
  end

  describe 'POST #create' do
    subject { post :create, pet: attributes }
    let(:user) { FactoryGirl.create :user }
    before do
      controller.stub(:current_user).and_return user
    end
    context 'with valid attributes' do
      let(:attributes) { valid_attributes }
      it 'should add a new pet to the current user' do
        expect {subject}.to change{user.pets.count}.by(1)
      end

      it 'should redirect back to the pets list' do
        subject
        response.should redirect_to pets_path
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { valid_attributes(name: nil) }
      it 'should not add a new pet to the current user' do
        expect {subject}.not_to change{user.pets.count}.by(1)
      end

      it 'should re-render the new template' do
        subject
        response.should render_template :new
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, id: pet.id }
    let(:pet) { stub_model(Pet) }
    before { controller.stub_chain(:current_user, :pets, :find).and_return pet }

    it 'should make a the pet object available to views for editing' do
      subject
      assigns(:pet).should == pet
    end

    it 'should render the edit template' do
      subject
      response.should render_template :edit
    end
  end

  describe 'PUT #update' do
    subject { put :update, id: pet.id, pet: attributes }
    let(:user) { FactoryGirl.create :user }
    let(:pet) { FactoryGirl.create :pet }
    before do
      controller.stub(:current_user).and_return user
      user.pets << pet
    end

    context 'with valid attributes' do
      let(:attributes) { valid_attributes }
      it 'should update the pets details' do
        subject
        pet.reload.name.should == valid_attributes[:name]
      end

      it 'should redirect back to the pets list' do
        subject
        response.should redirect_to pets_path
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { valid_attributes(name: nil) }
      it 'should not update the pet attributes' do
        subject
        pet.size.should_not == valid_attributes[:size]
      end

      it 'should re-render the edit template' do
        subject
        response.should render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, id: pet.id}
    let(:user) { FactoryGirl.create :user }
    let(:pet) { FactoryGirl.create :pet }
    before do
      controller.stub(:current_user).and_return user
      user.pets << pet
    end

    it 'should remove the pet' do
      expect{ subject }.to change{user.pets.count}.by(-1)
    end
  end
end
