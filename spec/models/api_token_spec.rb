require 'rails_helper'

RSpec.describe ApiToken, type: :model do

  describe 'validations' do
    it 'checks uniqueness of code' do
      expect(subject).to validate_uniqueness_of(:code)
    end

    it 'checks presence of name' do
      expect(subject).to validate_presence_of(:name)
    end

    it 'checks uniqueness of name' do
      expect(subject).to validate_uniqueness_of(:name)
    end
  end

  describe 'callbacks' do
    describe 'before save' do

      subject { build(:api_token) }

      context 'code is present' do
        it 'retains the existing code' do
          subject.code = 'super-secret-code'
          subject.save
          expect(subject.code).to eq('super-secret-code')
        end
      end

      context 'code is absent' do
        it 'generates a new 36-character code' do
          subject.save
          expect(subject.code.length).to eq(36)
        end
      end
    end
  end

end
