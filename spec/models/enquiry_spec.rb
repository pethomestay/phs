require 'spec_helper'

describe Enquiry do
  before do
    ProviderMailer.stub(:enquiry).and_return mock(:mail, deliver: true)
    Homestay.any_instance.stub(:geocode).and_return true
  end

  it { should belong_to :user }
  it { should belong_to :homestay }

  it { should have_many :feedbacks }
  it { should have_and_belong_to_many :pets }

  it { should have_one :booking }

  describe '#need_feedback' do
	  subject { Enquiry.need_feedback }
	  context 'when no enquiry needed feedback' do
		  let(:enquiry) { FactoryGirl.create :enquiry }
		  it 'should return empty []' do
			  subject.should be_blank
		  end
	  end
	  context 'when enquiry needed feedback' do
		  let(:enquiry) { FactoryGirl.create :enquiry, owner_accepted: true, check_in_date: Time.zone.now - 3.days }
		  it 'should return 1 enquiry' do
			  enquiry
			  subject.size.should be_eql(1)
		  end
	  end
  end

  describe '#duration_name' do
    subject { enquiry.duration_name }
    context 'when the Enquiry has no duration' do
      let(:enquiry) { Enquiry.new()}
      it 'should return nil' do
        subject.should be_nil
      end
    end
    context 'when the Enquiry has a duration' do
      let(:enquiry) { Enquiry.new(duration_id: ReferenceData::Duration::MORNING.id)}
      it 'should return the title of the duration' do
        subject.should == ReferenceData::Duration::MORNING.title
      end
    end
  end

  describe '#response_name' do
    subject { enquiry.response_name }
    context 'when the Enquiry has no response' do
      let(:enquiry) { Enquiry.new()}
      it 'should return nil' do
        subject.should be_nil
      end
    end
    context 'when the Enquiry has a response' do
      let(:enquiry) { Enquiry.new(response_id: ReferenceData::Response::ACCEPTED.id)}
      it 'should return the title of the response' do
        subject.should == ReferenceData::Response::ACCEPTED.title
      end
    end
  end

  describe '#feedback_for_owner' do
    subject { enquiry.feedback_for_owner }
    let(:enquiry) { FactoryGirl.create :enquiry }

    context 'when feedback has been provided for the owner' do
      let!(:feedback) { enquiry.feedbacks.create!(user: enquiry.homestay.user, subject: enquiry.user, rating: 2)}
      it 'should return the owner feedback' do
        subject.should == feedback
      end
    end

    context 'when no feedback has been provided for the owner' do
      it 'should return nil' do
        subject.should be_nil
      end
    end
  end

  describe '#feedback_for_owner?' do
    subject { enquiry.feedback_for_owner? }
    let(:enquiry) { FactoryGirl.create :enquiry }

    context 'when feedback has been provided for the owner' do
      let!(:feedback) { enquiry.feedbacks.create!(user: enquiry.homestay.user, subject: enquiry.user, rating: 2)}
      it { should be_true }
    end

    context 'when no feedback has been provided for the owner' do
      it { should be_false }
    end
  end

  describe '#feedback_for_homestay' do
    subject { enquiry.feedback_for_homestay }
    let(:enquiry) { FactoryGirl.create :enquiry }

    context 'when feedback has been provided for the owner' do
      let!(:feedback) { enquiry.feedbacks.create!(user: enquiry.user, subject: enquiry.homestay.user, rating: 2)}
      it 'should return the owner feedback' do
        subject.should == feedback
      end
    end

    context 'when no feedback has been provided for the owner' do
      it 'should return nil' do
        subject.should be_nil
      end
    end
  end

  describe '#feedback_for_homestay?' do
    subject { enquiry.feedback_for_homestay? }
    let(:enquiry) { FactoryGirl.create :enquiry }

    context 'when feedback has been provided for the owner' do
      let!(:feedback) { enquiry.feedbacks.create!(user: enquiry.user, subject: enquiry.homestay.user, rating: 2)}
      it { should be_true }
    end

    context 'when no feedback has been provided for the owner' do
      it { should be_false }
    end
  end
end
