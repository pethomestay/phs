require 'spec_helper'

describe Admin::EnquiriesHelper do
  before do
    helper.extend Haml
    helper.extend Haml::Helpers
    helper.send :init_haml_helpers
  end

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

  describe '#feedback_for_homestay_label' do
    subject { helper.feedback_for_homestay_label enquiry }
    before { helper.stub(:homestay_feedback_params).and_return {}}
    context 'when the enquiry has feedback for the homestay' do
      let(:enquiry) { stub_model(Enquiry, feedback_for_homestay?: true, feedback_for_homestay: mock(:feedback, rating: 3))}
      it 'should render the rating_stars' do
        helper.should_receive(:rating_stars).with(enquiry.feedback_for_homestay.rating)
        subject
      end
    end

    context 'when the enquiry has no feedback for the homestay' do
      let(:enquiry) { stub_model(Enquiry, feedback_for_homestay?: false)}
      it 'should render a span with none' do
        helper.capture_haml{subject}.should =~ /<span>none<\/span>/
      end

      it 'should render a link to add feedback for the homestay' do
        helper.capture_haml{subject}.should =~ /<a href="\/admin\/feedbacks\/new" class="btn btn-primary">Provide feedback to homestay<\/a>/
      end
    end
  end

  describe '#feedback_for_owner_label' do
    subject { helper.feedback_for_owner_label enquiry }
    before { helper.stub(:owner_feedback_params).and_return {}}
    context 'when the enquiry has feedback for the owner' do
      let(:enquiry) { stub_model(Enquiry, feedback_for_owner?: true, feedback_for_owner: mock(:feedback, rating: 3))}
      it 'should render the rating_stars' do
        helper.should_receive(:rating_stars).with(enquiry.feedback_for_owner.rating)
        subject
      end
    end

    context 'when the enquiry has no feedback for the owner' do
      let(:enquiry) { stub_model(Enquiry, feedback_for_owner?: false)}
      it 'should render a span with none' do
        helper.capture_haml{subject}.should =~ /<span>none<\/span>/
      end

      it 'should render a link to add feedback for the owner' do
        helper.capture_haml{subject}.should =~ /<a href="\/admin\/feedbacks\/new" class="btn btn-primary">Provide feedback to pet owner<\/a>/
      end
    end
  end
end
