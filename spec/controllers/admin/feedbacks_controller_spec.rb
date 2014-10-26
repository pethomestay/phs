require 'spec_helper'

describe Admin::FeedbacksController, :type => :controller do
  let(:user) { FactoryGirl.create :user }
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    allow(controller).to receive(:require_admin!).and_return true
  end

  def valid_attributes(override_or_add={})
    { rating: '3',

    }.merge(override_or_add)
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all feedbacks as @feedbacks" do
      allow(Feedback).to receive(:order).and_return 'all feedbacks'
      get :index, {}, valid_session
      expect(assigns(:feedbacks)).to eq('all feedbacks')
    end
  end

  describe "GET show" do
    it "assigns the requested feedback as @feedback" do
      feedback = Feedback.create! valid_attributes(subject: user)
      get :show, {id: feedback.to_param}, valid_session
      expect(assigns(:feedback)).to eq(feedback)
    end
  end

  describe "GET new" do
    it "assigns a new feedback as @feedback" do
      get :new, {}, valid_session
      expect(assigns(:feedback)).to be_a_new(Feedback)
    end
  end

  describe "GET edit" do
    it "assigns the requested feedback as @feedback" do
      feedback = Feedback.create! valid_attributes(subject: user)
      get :edit, {id: feedback.to_param}, valid_session
      expect(assigns(:feedback)).to eq(feedback)
    end
  end

  describe "POST create" do
    context "with valid params" do
      subject { post :create, {feedback: valid_attributes(user_id: 2, subject_id: user.id, enquiry_id: 3)}, valid_session }
      it "creates a new Feedback" do
        expect { subject }.to change(Feedback, :count).by(1)
      end

      it "assigns a newly created feedback as @feedback" do
        subject
        expect(assigns(:feedback)).to be_a(Feedback)
        expect(assigns(:feedback)).to be_persisted
      end

      it "redirects to the created feedback" do
        subject
        expect(response).to redirect_to(admin_feedback_path(Feedback.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved feedback as @feedback" do
        post :create, {feedback: {  }}, valid_session
        expect(assigns(:feedback)).to be_a_new(Feedback)
      end

      it "re-renders the 'new' template" do
        post :create, {feedback: {  }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:feedback) { Feedback.create! valid_attributes(subject: user) }
    describe "with valid params" do
      subject { put :update, {id: feedback.to_param, feedback: valid_attributes}, valid_session }
      it "updates the requested feedback" do
        expect_any_instance_of(Feedback).to receive(:update_attributes).with({ "these" => "params" })
        put :update, {id: feedback.to_param, feedback: { "these" => "params" }}, valid_session
      end

      it "assigns the requested feedback as @feedback" do
        subject
        expect(assigns(:feedback)).to eq(feedback)
      end

      it "redirects to the feedback" do
        subject
        expect(response).to redirect_to(admin_feedback_path(feedback))
      end
    end

    describe "with invalid params" do
      subject { put :update, {id: feedback.to_param, feedback: {rating: '' }}, valid_session }
      it "assigns the feedback as @feedback" do
        subject
        expect(assigns(:feedback)).to eq(feedback)
      end

      it "re-renders the 'edit' template" do
        subject
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, {id: feedback.to_param}, valid_session }
    let(:feedback) { stub_model(Feedback, destroy: true) }
    before { allow(Feedback).to receive(:find).and_return feedback }

    it "destroys the requested feedback" do
      expect(feedback).to receive(:destroy)
      subject
    end

    it "redirects to the feedbacks list" do
      subject
      expect(response).to redirect_to(admin_feedback_path(feedback))
    end
  end

end
