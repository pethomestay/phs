require 'rails_helper'

RSpec.describe Device, type: :model do
  describe 'validations' do
    it 'checks presence of token' do
      expect(subject).to validate_presence_of(:token)
    end

    it 'checks uniqueness of token' do
      expect(subject).to validate_uniqueness_of(:token).scoped_to(:user_id)
    end

    it 'checks presence of user ID' do
      expect(subject).to validate_presence_of(:user_id)
    end
  end
end
