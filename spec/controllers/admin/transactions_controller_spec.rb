require 'spec_helper'

describe Admin::TransactionsController do
  let(:booking) { FactoryGirl.create :booking }
  before do
    controller.stub(:authenticate_user!).and_return true
    controller.stub(:require_admin!).and_return true
  end

  def valid_attributes(override_or_add={})
    r = Random.new
    amount = r.rand(10...60) + 0.5
    time_stamp = Time.now.gmtime.strftime("%Y%m%d%H%M%S")
    type_code = "1"
    reference = "transaction_id=27"
    fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{type_code}|#{reference}|#{amount}|#{time_stamp}"
    {
      booking_id: "#{booking.id}",
      transaction_id: "0000" + r.rand(10...99).to_s,
      time_stamp: time_stamp,
      merchant_fingerprint:  Digest::SHA1.hexdigest(fingerprint_string).to_s,
      pre_authorisation_id: "R87526",
      response_text: "TRANSACTION APPROVED",
      amount: amount,
      secure_pay_fingerprint: "0f10edb46492804295a7442800b26bd28b29e326",
      reference: reference,
      type_code: type_code,
      storage_text: nil,
      status:  "Pre authorization required",
      card_id: nil
    }.merge(override_or_add)
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all transactions as @transactions" do
      t1 = FactoryGirl.create :transaction
      t2 = FactoryGirl.create :transaction
      t3 = FactoryGirl.create :transaction
      get :index, {}, valid_session
      assigns(:transactions).should eq [t3, t2, t1]
    end
  end

  describe "GET show" do
    it "assigns the requested transaction as @transaction" do
      transaction = Transaction.create! valid_attributes(booking:booking)
      get :show, {:id => transaction.to_param}, valid_session
      assigns(:transaction).should eq(transaction)
    end
  end


  describe "GET edit" do
    it "assigns the requested transaction as @transaction" do
      transaction = Transaction.create! valid_attributes(booking:booking)
      get :edit, {:id => transaction.to_param}, valid_session
      assigns(:transaction).should eq(transaction)
    end
  end


  describe "PUT update" do
    let(:transaction) { Transaction.create! valid_attributes(booking:booking) }


    describe "with valid params" do
      subject { put :update, {:id => transaction.to_param, :transaction => valid_attributes(booking:booking)}, valid_session }
      it "updates the requested transaction" do
        Transaction.any_instance.should_receive(:update_attributes).with({ "response_text" => "TRANSACTION DENINED" })
        put :update, {:id => transaction.to_param, :transaction => { "response_text" => "TRANSACTION DENINED" }}, valid_session
      end

      it "assigns the requested transaction as @transaction" do
        subject
        assigns(:transaction).should eq(transaction)
      end

      it "redirects to the transaction" do
        subject
        response.should redirect_to(admin_transaction_path(transaction))
      end
    end
  end


end
