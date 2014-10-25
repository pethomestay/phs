require 'spec_helper'

describe ContactsController, :type => :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    request.env["HTTP_REFERER"] = new_contact_path
  end

  def valid_attributes(override_or_add={})
    { 'name' => 'fred', 'email' => 'fred@test.com', 'message' => 'awesome application!' }.merge(override_or_add)
  end


  describe 'GET #new' do
    subject { get :new }

    it 'should make a new pet object available to views' do
      subject
      expect(assigns(:contact)).to be_a Contact
    end

    it 'should render the new template' do
      subject
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    subject { post :create, contact: attributes }

    context 'with valid attributes' do
      let(:attributes) { valid_attributes }
      it 'should sned a contact email' do
        expect_any_instance_of(Contact).to receive(:send_email)
        subject
      end

      it 'should redirect back to the pets list' do
        subject
        expect(response).to redirect_to new_contact_path
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { valid_attributes('name' => '') }
      it 'should not send a contact email' do
        expect_any_instance_of(Contact).not_to receive(:send_email)
        subject
      end

      it 'should re-render the new template' do
        subject
        expect(response).to render_template :new
      end
    end
  end
end
