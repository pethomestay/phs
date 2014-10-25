require "spec_helper"

describe UnavailableDatesController, :type => :controller do

  let(:user){ FactoryGirl.build(:user, id: 1) }
  let(:unavailable_date) { FactoryGirl.build(:unavailable_date, user: user, id: 1) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe "Post #Create" do

    context "when valid params are sent" do

      subject { post :create, unavailable_date: { date: Date.today } }

      it "should create unavailable date successfully" do
        expect{ subject }.to change{ UnavailableDate.count }.by(1)
      end

      it "should return 200 status code" do
        allow_any_instance_of(UnavailableDate).to receive(:save).and_return(true)
        expect(subject.code).to eq("200")
      end

      it "should return appropriate message" do
        allow_any_instance_of(UnavailableDate).to receive(:save).and_return(true)
        res = JSON.parse subject.body
        expect(res["message"]).to eq(I18n.t("unavailable_date.successfully_created"))
      end

    end

    context "when invalid params are sent" do

      subject { post :create, unavailable_date: { date: Date.today - 1 } }

      it "should return 401 status code" do
        expect(subject.code).to eq("400")
      end

      it "should return an error message" do
        unavailable_date.date = Date.today - 1
        expect(unavailable_date.valid?).to eq(false)
        res = JSON.parse subject.body
        expect(res["message"]).to eq(JSON.parse(unavailable_date.errors.messages.to_json))
      end

    end

  end


  describe "DELETE #destroy" do

    subject { delete :destroy, id: unavailable_date.id }

    context "when id is valid" do
      
      before do
        unavailable_date.save
      end

      it "should destroy the unavailable date" do
        expect { subject }.to change{ UnavailableDate.count }.by(-1)
      end

      it "should reutrn 200 status code" do
        expect(subject.code).to eq("200")
      end

      it "should return appropriate message" do
        res = JSON.parse subject.body
        expect(res["message"]).to eq(I18n.t("unavailable_date.successfully_destroyed"))
      end

    end

    context "when invalid id is passed" do

      it "should raise an active record not found error" do
        expect{ delete :destroy, id: "invalid_id" }.to raise_error(ActiveRecord::RecordNotFound)
      end

    end

  end

end
