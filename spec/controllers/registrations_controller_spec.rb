

describe RegistrationsController, :type => :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    allow(controller).to receive(:current_user).and_return user
    allow(controller).to receive(:authenticate_user!).and_return true
  end
  let(:user) { stub_model(User, update_attributes: true, email: 'test@test.com')}
  describe 'DELETE #destroy' do
    subject { delete :destroy }
    before {Timecop.freeze(Time.zone.now) }
    after { Timecop.return }

    it 'should set the user active field to false' do
      expect(user).to receive(:update_attributes).with(hash_including(active: false))
      subject
    end

    it 'should alter the email field appending .timestamp.old' do
      expect(user).to receive(:update_attributes).with(hash_including(email: "test@test.com.#{Time.zone.now.to_i}.old"))
      subject
    end

    context 'when the user has a homestay' do
      let(:homestay) { stub_model(Homestay, :active= => true) }
      before { allow(user).to receive(:homestay).and_return(homestay) }
      it 'should set the homestay active field to false' do
        expect(homestay).to receive(:active=).with false
        subject
      end
    end
  end
end
