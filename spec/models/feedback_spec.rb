require 'spec_helper'

describe Feedback do
  it { should belong_to :user }
  it { should belong_to :subject }
  it { should belong_to :enquiry }

  describe 'creation' do
    subject { Feedback.create!(enquiry: enquiry, subject: user, rating: 3)}
    let(:user) { stub_model(User)}
    let(:enquiry) { stub_model(Enquiry)}
    it 'should call update_average_rating on its user' do
      user.should_receive(:update_average_rating)
      subject
    end
  end
end
