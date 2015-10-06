RSpec.shared_context 'api skeleton' do
  let!(:token) { create(:api_token, code: '12345678') }

  before(:each) do
    host! 'api.example.com'
  end
end
