require 'spec_helper'

describe Admin::UsersController do
  before do
    controller.stub(:authenticate_user!).and_return true
    controller.stub(:require_admin!).and_return true
  end

  def valid_attributes
    { email: Faker::Internet.email,
      password: 'abcdefghijk',
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      date_of_birth: Time.zone.now - 18.years,
      address_1: Faker::Address.street_address,
      address_suburb: 'Collingwood',
      address_city: 'Melbourne',
      mobile_number: '04 55 555 555',
      address_country: 'AU' }
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all users as @users" do
      u1 = FactoryGirl.create :user
      u2 = FactoryGirl.create :user
      u3 = FactoryGirl.create :user
      get :index, {}, valid_session
      assigns(:users).should eq [u3, u2, u1]
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      get :show, {:id => user.to_param}, valid_session
      assigns(:user).should eq(user)
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new, {}, valid_session
      assigns(:user).should be_a_new(User)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      get :edit, {:id => user.to_param}, valid_session
      assigns(:user).should eq(user)
    end
  end

  describe "POST create" do
    context "with valid params" do
      subject { post :create, {:user => valid_attributes}, valid_session }
      it "creates a new User" do
        expect { subject }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        subject
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to the created user" do
        post :create, {:user => valid_attributes}, valid_session
        response.should redirect_to(admin_user_path(User.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        post :create, {:user => {  }}, valid_session
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        post :create, {:user => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:user) { User.create! valid_attributes }
    describe "with valid params" do
      subject { put :update, {:id => user.to_param, :user => valid_attributes}, valid_session }
      it "updates the requested user" do
        User.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => user.to_param, :user => { "these" => "params" }}, valid_session
      end

      it "assigns the requested user as @user" do
        subject
        assigns(:user).should eq(user)
      end

      it "redirects to the user" do
        subject
        response.should redirect_to(admin_user_path(user))
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        put :update, {:id => user.to_param, :user => {email: '' }}, valid_session
        assigns(:user).should eq(user)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => user.to_param, :user => { email: '' }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, {:id => user.to_param}, valid_session }
    let!(:user) { User.create! valid_attributes }
    it "destroys the requested user" do
      expect { subject }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      subject
      response.should redirect_to(admin_users_url)
    end
  end

end
