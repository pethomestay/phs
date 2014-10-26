require 'rails_helper'

describe Admin::AdminController, :type => :controller do
  before { allow(controller).to receive(:authenticate_user!).and_return true }

  describe 'require_admin!' do
    subject { controller.send(:require_admin!) }
    before { allow(controller).to receive(:current_user).and_return user }
    context 'when the current user is an admin' do
      let(:user) { stub_model(User, admin?: true) }
      it 'should return nil' do
        expect(subject).to be_nil
      end
      it 'should not render any template' do
        expect(controller).not_to receive(:render)
      end
    end
    context 'when the current user is not an admin' do
      let(:user) { stub_model(User, admin?: false) }
      it 'should render the 403 template' do
        expect(controller).to receive(:render).with(file: "#{Rails.root}/public/403", format: :html, status: 403)
        subject
      end
    end
  end

  describe 'GET #dashboard' do
    subject { get :dashboard }
    before { allow(controller).to receive(:require_admin!).and_return true }

    it 'should render the dashboard view' do
      subject
      expect(response).to render_template :dashboard
    end

    it 'should make stas available for rendering' do
      subject
      expect(assigns(:stats)).not_to be_nil
    end

    it 'should make recently signed up users available for rendering' do
      allow(User).to receive(:last_five).and_return 'last five'
      subject
      expect(assigns(:users)).to eq('last five')
    end

    it 'should make recently signed up homestays available for rendering' do
      allow(Homestay).to receive(:last_five).and_return 'last five homestays'
      subject
      expect(assigns(:homestays)).to eq('last five homestays')
    end
  end
end
