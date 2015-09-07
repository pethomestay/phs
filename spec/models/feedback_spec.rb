require 'rails_helper'

RSpec.describe Feedback, type: :model do
  let(:user) { create :user }
  let(:feedback) { build :feedback, subject: user }

  describe 'callbacks' do
    it 'updates user average rating on create' do
      expect(user.average_rating).to eq nil
      feedback.save
      expect(user.average_rating).to_not eq nil
    end
  end

  describe '.average_rating' do
    context 'with feedback' do
      before :each do
        feedback.save
      end

      it 'returns average rating of all feedbacks in collection' do
        expect(user.received_feedbacks.average_rating).to eq feedback.rating
      end
    end

    context 'without feedback' do
      it 'returns 0' do
        expect(user.received_feedbacks.average_rating).to eq 0
      end
    end
  end
end
