require 'spec_helper'

describe Admin::EnquiriesHelper, :type => :helper do
  before do
    helper.extend Haml
    helper.extend Haml::Helpers
    helper.send :init_haml_helpers
  end

  describe '#homestay_feedback_params' do
    let(:enquiry) { stub_model(Enquiry, user: stub_model(User), homestay: stub_model(Homestay, user: stub_model(User))) }
    subject { helper.homestay_feedback_params enquiry }

    it 'should provide the enquiry_id from the enquiry' do
      expect(subject[:feedback][:enquiry_id]).to eq(enquiry.id)
    end
    it 'should provide the enquiry user id as the user id' do
      expect(subject[:feedback][:user_id]).to eq(enquiry.user.id)
    end
    it 'should provide the enquiry homestay owner id as the subject id' do
      expect(subject[:feedback][:subject_id]).to eq(enquiry.homestay.user.id)
    end
  end

  describe '#owner_feedback_params' do
    let(:enquiry) { stub_model(Enquiry, user: stub_model(User), homestay: stub_model(Homestay, user: stub_model(User))) }
    subject { helper.owner_feedback_params enquiry }

    it 'should provide the enquiry_id from the enquiry' do
      expect(subject[:feedback][:enquiry_id]).to eq(enquiry.id)
    end
    it 'should provide the enquiry user id as the subject id' do
      expect(subject[:feedback][:subject_id]).to eq(enquiry.user.id)
    end
    it 'should provide the enquiry homestay owner id as the user id' do
      expect(subject[:feedback][:user_id]).to eq(enquiry.homestay.user.id)
    end
  end

  describe '#feedback_for_homestay_label' do
    subject { helper.feedback_for_homestay_label enquiry }
    before { allow(helper).to receive(:homestay_feedback_params) {}}
    context 'when the enquiry has feedback for the homestay' do
      let(:enquiry) { stub_model(Enquiry, feedback_for_homestay?: true, feedback_for_homestay: double(:feedback, rating: 3))}
      it 'should render the rating_stars' do
        expect(helper).to receive(:rating_stars).with(enquiry.feedback_for_homestay.rating)
        subject
      end
    end

    context 'when the enquiry has no feedback for the homestay' do
      let(:enquiry) { stub_model(Enquiry, feedback_for_homestay?: false)}
      it 'should render a span with none' do
        expect(helper.capture_haml{subject}).to match(/<span>none<\/span>/)
      end

      it 'should render a link to add feedback for the homestay' do
        expect(helper.capture_haml{subject}).to match(/<a href="\/admin\/feedbacks\/new" class="btn btn-primary">Provide feedback to homestay<\/a>/)
      end
    end
  end

  describe '#feedback_for_owner_label' do
    subject { helper.feedback_for_owner_label enquiry }
    before { allow(helper).to receive(:owner_feedback_params) {}}
    context 'when the enquiry has feedback for the owner' do
      let(:enquiry) { stub_model(Enquiry, feedback_for_owner?: true, feedback_for_owner: double(:feedback, rating: 3))}
      it 'should render the rating_stars' do
        expect(helper).to receive(:rating_stars).with(enquiry.feedback_for_owner.rating)
        subject
      end
    end

    context 'when the enquiry has no feedback for the owner' do
      let(:enquiry) { stub_model(Enquiry, feedback_for_owner?: false)}
      it 'should render a span with none' do
        expect(helper.capture_haml{subject}).to match(/<span>none<\/span>/)
      end

      it 'should render a link to add feedback for the owner' do
        expect(helper.capture_haml{subject}).to match(/<a href="\/admin\/feedbacks\/new" class="btn btn-primary">Provide feedback to pet owner<\/a>/)
      end
    end
  end
end
