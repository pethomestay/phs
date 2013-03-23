require 'spec_helper'

describe ContactsController do
  before do
    controller.stub(:authenticate_user!).and_return true
  end

  def valid_attributes(override_or_add={})
    { 'name' => 'fred', 'email' => 'fred@test.com', 'message' => 'awesome application!' }.merge(override_or_add)
  end


  describe 'GET #new' do
    subject { get :new }

    it 'should make a new pet object available to views' do
      subject
      assigns(:contact).should be_a Contact
    end

    it 'should render the new template' do
      subject
      response.should render_template :new
    end
  end

  describe 'POST #create' do
    subject { post :create, contact: attributes }

    context 'with valid attributes' do
      let(:attributes) { valid_attributes }
      it 'should sned a contact email' do
        Contact.any_instance.should_receive(:send_email)
        subject
      end

      it 'should redirect back to the pets list' do
        subject
        response.should redirect_to new_contact_path
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { valid_attributes('name' => '') }
      it 'should not send a contact email' do
        Contact.any_instance.should_not_receive(:send_email)
        subject
      end

      it 'should re-render the new template' do
        subject
        response.should render_template :new
      end
    end
  end
end
