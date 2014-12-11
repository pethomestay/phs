

describe UsersController, :type => :controller do
  before do
    allow(controller).to receive(:current_user).and_return user
    allow(controller).to receive(:authenticate_user!).and_return true
  end
  let(:user) { stub_model(User) }

  describe 'GET #show' do
    subject { get :show }
    it 'should make the user available for rendering' do
      subject
      expect(assigns(:user)).to eq(user)
    end

    it 'should render the show template' do
      subject
      expect(response).to render_template :show
    end
  end
end
