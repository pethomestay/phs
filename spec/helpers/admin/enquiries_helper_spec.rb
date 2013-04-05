require 'spec_helper'

describe Admin::EnquiriesHelper do
  describe '#homestay_feedback_params' do
    let(:enquiry) { stub_model(Enquiry, user: stub_model(User), homestay: stub_model(Homestay, user: stub_model(User))) }
    subject { helper.homestay_feedback_params enquiry }

    it 'should provide the enquiry_id from the enquiry' do
      subject[:feedback][:enquiry_id].should == enquiry.id
    end
    it 'should provide the enquiry user id as the user id' do
      subject[:feedback][:user_id].should == enquiry.user.id
    end
    it 'should provide the enquiry homestay owner id as the subject id' do
      subject[:feedback][:subject_id].should == enquiry.homestay.user.id
    end
  end

  describe '#owner_feedback_params' do
    let(:enquiry) { stub_model(Enquiry, user: stub_model(User), homestay: stub_model(Homestay, user: stub_model(User))) }
    subject { helper.owner_feedback_params enquiry }

    it 'should provide the enquiry_id from the enquiry' do
      subject[:feedback][:enquiry_id].should == enquiry.id
    end
    it 'should provide the enquiry user id as the subject id' do
      subject[:feedback][:subject_id].should == enquiry.user.id
    end
    it 'should provide the enquiry homestay owner id as the user id' do
      subject[:feedback][:user_id].should == enquiry.homestay.user.id
    end
  end
end
