require 'spec_helper'

RSpec.describe ReferralCodeGenerator do
  let(:model) { double(first_name: 'John', last_name: 'Doe') }
  let(:generator) { ReferralCodeGenerator.new(model, {}) }

  let(:custom_args) do 
    {
      custom_discount: 123123,
      custom_credit: 123123,
      custom_code: 123123
    }
  end

  describe "#initialize" do
    it "sets args" do
      expect(generator.args).to_not eq nil
    end

    it "sets model" do
      expect(generator.model).to_not eq nil
    end
  end

  describe "#generate" do
    context "without args" do
      it "returns owned coupons hash" do
        expect(generator.generate).to eq({
          code: "JOHND10",
          discount_amount: 10,
          credit_referrer_amount: 5,
          valid_from: Date.today
        })
      end
    end

    context "with args" do
      context "without custom code arg" do
        before :each do
          custom_args[:custom_code] = nil
          generator.args = custom_args
        end

        it "returns data from arg" do
          expect(generator.generate).to eq({
            code: 'JOHND10',
            discount_amount: 123123,
            credit_referrer_amount: 123123,
            valid_from: Date.today
          })
        end
      end

      context "with custom code arg" do
        before :each do
          custom_args[:custom_code] = "hello"
          generator.args = custom_args
        end

        it "returns data from arg with custom code" do
          expect(generator.generate).to eq({
            code: "HELLO",
            discount_amount: 123123,
            credit_referrer_amount: 123123,
            valid_from: Date.today
          })
        end
      end
    end
  end
end
