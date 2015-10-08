require 'rails_helper'

RSpec.describe HomestaysController, type: :controller do

  describe 'GET #index' do
    let(:valid_params) do
      {
        search: {
                location: "Australia",
           check_in_date: DateTime.current.to_s,
          check_out_date: DateTime.current.to_s
        }
      }
    end

    context "with valid params" do
      subject { get :index, valid_params }

      it "assigns @search" do
        subject

        expect(assigns(:search)).to_not be_nil
        expect(assigns(:search)).to be_a Search
      end

      it "assigns @homestays" do
        subject

        expect(assigns(:homestays)).to_not be_nil
        expect(assigns(:homestays)).to be_a Array
      end

      it "performs a homestay search" do
        allow_any_instance_of(HomestaySearch).to receive(:results).and_return([])

        expect_any_instance_of(HomestaySearch).to receive(:perform_search)
        subject
      end

      it "pushes to gon" do
        expect(controller.gon).to receive(:push)

        subject
      end

      it "renders index" do
        expect(subject).to render_template(:index)
      end
    end

    context "with invalid params" do
      subject { get :index, {} }

      it "redirects to root_path" do
        expect(subject).to redirect_to root_path
      end
    end
  end

  describe 'GET #show' do
    before do
      allow(controller).to receive(:track_session_variables) { true }
    end

    context "with valid params" do
      let!(:homestay) { create :homestay, slug: "valid" }
      let!(:feedback) { create :feedback, subject_id: homestay.user_id }

      subject { get :show, { id: homestay.slug } }

      it "assigns @homestay" do
        subject

        expect(assigns(:homestay)).to_not be_nil
        expect(assigns(:homestay)).to be_a Homestay
      end

      it "assigns @reviews" do
        subject

        expect(assigns(:reviews)[0]).to be_a Feedback
      end

      it "assigns @response_rate_in_percent" do
        subject

        expect(assigns(:response_rate_in_percent)).to eq assigns(:homestay).user.response_rate_in_percent
      end

      it "pushes to gon" do
        expect(controller.gon).to receive(:push)

        subject
      end

      it "renders show" do
        expect(subject).to render_template(:show)
      end

      context "when authenticated" do
        let!(:user) { create :user }
        let!(:pets) { create_list :pet, 5, user_id: user.id }

        before do
          allow(controller).to receive(:user_signed_in?).and_return(true)
          allow(controller).to receive(:current_user).and_return(user)

          subject
        end

        describe "@enquiry" do
          it "has user and pets" do
            expect(assigns(:enquiry).user).to eq user
            expect(assigns(:enquiry).pets.sort).to eq pets.sort
            expect(assigns(:enquiry).check_in_date).to eq Date.today
            expect(assigns(:enquiry).check_out_date).to eq Date.today
          end
        end

        describe "@reusable_enquiries" do
          it "does not return nil" do
            expect(assigns(:reusable_enquiries)).to_not be_nil
          end
        end
      end

      context "when unauthenticated" do
        before { subject }

        describe "@enquiry" do
          it "has no user and pets" do
            expect(assigns(:enquiry).user).to be_nil
            expect(assigns(:enquiry).pets).to be_empty
            expect(assigns(:enquiry).check_in_date).to eq Date.today
            expect(assigns(:enquiry).check_out_date).to eq Date.today
          end
        end

        describe "@reusable_enquiries" do
          it "returns nil" do
            expect(assigns(:reusable_enquiries)).to be_nil
          end
        end
      end

      context "when inactive listing" do
        before do
          allow_any_instance_of(Homestay).to receive(:inactive_listing?).and_return(true)

          subject
        end

        it "flashes a notice" do
          expect(flash[:notice]).to eq I18n.t('controller.homestay.show.notice.inactive')
        end
      end
    end

    context "with invalid params" do
      subject { get :show, { id: "invalid" } }

      it "raises an error" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #activate' do
    before do
      allow(controller).to receive(:authenticate_user!) { true }
    end

    context "when homestay is active" do
      let!(:homestay) { create :homestay, active: true }
      before { post :activate, { id: homestay.slug }, format: :js }

      it "updates active to false" do
        expect(homestay.reload.active?).to eq false
      end
    end

    context "when homestay is inactive" do
      let!(:homestay) { create :homestay, active: false }
      before { post :activate, { id: homestay.slug }, format: :js }

      it "updates active to true" do
        expect(homestay.reload.active?).to eq true
      end
    end
  end

  describe 'GET #favourite' do
    let(:homestay) { create :homestay }

    before do
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { create :user }
    end

    subject { get :favourite, id: homestay.id }

    it "creates a favourite record" do
      expect { subject }.to change { homestay.favourites.count }.by(1)
    end
  end

  describe 'GET #non_favourite' do
    let!(:favourite) { create :favourite }
    let!(:homestay)  { favourite.homestay }
    let!(:user)      { favourite.user }

    before do
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { user }
    end

    subject { get :non_favourite, id: homestay.id }

    context "with favourite" do
      it "destroys favourite record" do
        expect { subject }.to change { homestay.favourites.count }.from(1).to(0)
      end

      it "responds status 200" do
        expect(subject).to have_http_status(200)
      end
    end

    context "without favourite" do
      before { homestay.favourites.first.destroy }

      it "does not perform destroy" do
        expect { subject }.to_not change { homestay.favourites.count }
      end

      it "responds status 302" do
        expect(subject).to have_http_status(302)
      end
    end
  end

  describe "#search?" do
    context "with search params" do
      before do
        controller.params = { search: { location: "Australia" } }
      end

      it { expect(controller.send(:search?)).to eq true }
    end

    context "without search params" do
      before do
        controller.params = {}
      end

      it { expect(controller.send(:search?)).to eq false }
    end
  end

  describe "#build_enquiry" do
    let(:user) do
      u = build :user
      u.pets = create_list :pet, 5
      u.save!

      return u
    end

    context "when authenticated" do
      before do
        allow(controller).to receive(:user_signed_in?).and_return(true)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it "has user and pets" do
        expect(controller.send(:build_enquiry).user).to eq user
        expect(controller.send(:build_enquiry).pets).to eq user.pets
        expect(controller.send(:build_enquiry).check_in_date).to eq Date.today
        expect(controller.send(:build_enquiry).check_out_date).to eq Date.today
      end
    end

    context "when unauthenticated" do
      it "does not have user and pets" do
        expect(controller.send(:build_enquiry).user).to be_nil
        expect(controller.send(:build_enquiry).pets).to be_empty
        expect(controller.send(:build_enquiry).check_in_date).to eq Date.today
        expect(controller.send(:build_enquiry).check_out_date).to eq Date.today
      end
    end
  end

  describe "#find_homestay_by_slug!" do
    context "with valid id" do
      let!(:homestay) { create :homestay, title: "valid" }
      before do
        allow(controller).to receive(:params).and_return({ id: homestay.slug })
      end

      it { expect(controller.send(:find_homestay_by_slug!)).to eq homestay }
    end

    context "with invalid id" do
      before do
        allow(controller).to receive(:params).and_return({ id: "invalid" })
      end

      it { expect { controller.send(:find_homestay_by_slug!) }.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe "#find_homestay_by_id" do
    context "with valid id" do
      let!(:homestay) { create :homestay, title: "valid-id" }
      before do
        allow(controller).to receive(:params).and_return({ id: homestay.id })
      end

      it { expect(controller.send(:find_homestay_by_id)).to eq homestay }
    end

    context "with invalid id" do
      before do
        allow(controller).to receive(:params).and_return({ id: "invalid" })
      end

      it { expect { controller.send(:find_homestay_by_id) }.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe "#parse_date" do
    let!(:date) { DateTime.current }

    it "works" do
      expected = Time.at(date.to_i).to_date
      expect(controller.send(:parse_date, date)).to eq expected
    end
  end

end
