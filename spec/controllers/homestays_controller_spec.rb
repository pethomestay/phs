require 'rails_helper'

RSpec.describe HomestaysController, type: :controller do

  describe 'GET #index' do
    before do
      allow(controller).to receive(:track_session_variables) { true }
    end

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
    pending
  end

  describe 'POST #activate' do
    pending
  end

  describe 'GET #favourite' do
    pending
  end

  describe 'GET #non_favourite' do
    pending
  end

  describe 'GET #availability' do
    pending
  end

  describe '#search?' do
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

end
