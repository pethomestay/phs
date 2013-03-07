require 'spec_helper'

describe HomestaysController do
  before do
    controller.stub(:authenticate_user!).and_return true
  end

  def valid_attributes(override_or_add={})
    {
      cost_per_night: '0',
      address_1: Faker::Address.street_address,
      address_suburb: 'Bondi',
      address_city: 'Sydney',
      address_country: 'AU',
      title: Faker::Company.name,
      description: Faker::Lorem.paragraph,
      property_type_id: '3',
      outdoor_area: 'large',
      accept_liability: '1',
      parental_consent: '1',
    }.merge(override_or_add)
  end

  describe 'GET #show' do
    subject { get :show, id: homestay.slug }
    let(:homestay) { Homestay.make! }
    it 'should make homestay to the pets variable' do
      subject
      assigns(:homestay).should == homestay
    end
  end

  describe 'GET #new' do
    subject { get :new }
    before { controller.stub_chain(:current_user, :build_homestay).and_return 'New Homestay' }

    it 'should make a new homestay object available to views' do
      subject
      assigns(:homestay).should == 'New Homestay'
    end

    it 'should render the new template' do
      subject
      response.should render_template :new
    end
  end

  describe 'POST #create' do
    subject { post :create, homestay: attributes }
    let(:user) { User.make! }
    before do
      controller.stub(:current_user).and_return user
    end
    context 'with valid attributes' do
      let(:attributes) { valid_attributes }
      it 'should create a new homestay for the current user' do
        subject
        user.homestay.should_not be_nil
      end

      it 'should redirect back to the pets list' do
        subject
        response.should redirect_to homestay_path(user.homestay.reload)
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { valid_attributes(address_1: nil) }
      it 'should not add a homestay for the current user' do
        subject
        user.reload.homestay.should be_nil
      end

      it 'should re-render the new template' do
        subject
        response.should render_template :new
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, id: homestay.slug }
    let(:homestay) { stub_model(Homestay, slug: 'my-homestay') }
    before { controller.stub_chain(:current_user, :homestay).and_return homestay }

    it 'should make a the homestay object available to views for editing' do
      subject
      assigns(:homestay).should == homestay
    end

    it 'should render the edit template' do
      subject
      response.should render_template :edit
    end
  end

  describe 'PUT #update' do
    subject { put :update, id: homestay.slug, homestay: attributes }
    let(:user) { User.make!(homestay: homestay) }
    let(:homestay) { Homestay.make! }
    before do
      controller.stub(:current_user).and_return user
    end

    context 'with valid attributes' do
      let(:attributes) { valid_attributes }
      it 'should update the homestays details' do
        subject
        homestay.reload.description.should == attributes[:description]
      end

      it 'should redirect back to the user account' do
        subject
        response.should redirect_to my_account_path
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { valid_attributes(address_1: nil) }
      it 'should not update the homestay attributes' do
        subject
        homestay.title.should_not == valid_attributes[:title]
      end

      it 'should re-render the edit template' do
        subject
        response.should render_template :edit
      end
    end
  end
end
