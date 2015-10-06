RSpec.shared_examples 'an authorised user' do |path, method|
  let(:user) { create(:user) }

  context 'user token is present' do
    context 'but unrecognised' do
      it 'returns 403' do
        user.hex = 'some-other-token'
        send method.to_sym, tokenised_path(path, user)
        expect(response).to match_error_code(403)
      end
    end

    context 'and recognised' do
      context 'and identifies an active user' do
        it 'pass authorisation' do
          send method.to_sym, tokenised_path(path, user)
          expect(response.status).to_not eq(403)
        end
      end

      context 'and identifies an inactive user' do
        it 'returns 403' do
          user.update_attribute(:active, false)
          send method.to_sym, tokenised_path(path, user)
          expect(response).to match_error_code(403)
        end
      end
    end
  end

  context 'user token is absent' do
    it 'returns 403' do
      send method.to_sym, tokenised_path(path)
      expect(response).to match_error_code(403)
    end
  end
end
