require 'spec_helper'

describe Enquiry do
   it { should belong_to :user }
   it { should belong_to :homestay }

   it { should have_many :feedbacks }
   it { should have_and_belong_to_many :pets }

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
        puts "RES:#{enquiry.response_id}"
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
end
