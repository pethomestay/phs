require 'spec_helper'

describe Feedback do
  it { should belong_to :user }
  it { should belong_to :enquiry }

  describe '#target_user' do
    subject { feedback.target_user }
    let(:user_1) { stub_model(User) }
    let(:user_2) { stub_model(User) }

    context 'when enquiry maker is the person who gave the feedback' do
      let(:feedback) { Feedback.new(user: user_1, enquiry: Enquiry.new(user: user_1, homestay: Homestay.new(user: user_2)))}
      it 'should return the homestay owner' do
        subject.should == user_2
      end
    end

    context 'when the homestay owner is the person who gave the feedback' do
      let(:feedback) { Feedback.new(user: user_2, enquiry: Enquiry.new(user: user_1, homestay: Homestay.new(user: user_2)))}
      it 'should return the enquiry maker' do
        subject.should == user_1
      end
    end
  end
end
