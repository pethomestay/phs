

describe Feedback, :type => :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :subject }
  it { is_expected.to belong_to :enquiry }

  describe 'creation' do
    subject { Feedback.create!(enquiry: enquiry, subject: user, rating: 3)}
    let(:user) { stub_model(User)}
    let(:enquiry) { stub_model(Enquiry)}
    it 'should call update_average_rating on its user' do
      expect(user).to receive(:update_average_rating)
      subject
    end
  end
end
