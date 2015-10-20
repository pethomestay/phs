require 'rails_helper'

RSpec.describe Visitor do

  it { is_expected.to respond_to(:id) }

  describe "#find_or_initialize_by_id" do
    context "id is present" do
      it { expect(Visitor.find_or_initialize_by_id("1").id).to eq "1" }
    end

    context "id is nil" do
      before { allow(SecureRandom).to receive(:hex).with(25).and_return("123") }

      it { expect(Visitor.find_or_initialize_by_id(nil).id).to eq "123" }
    end

    context "id is blank" do
      before { allow(SecureRandom).to receive(:hex).with(25).and_return("123") }

      it { expect(Visitor.find_or_initialize_by_id("").id).to eq "123" }
    end
  end

end
