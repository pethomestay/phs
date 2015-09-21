require 'rails_helper'

RSpec.describe HomestayDecorator do
  let!(:homestay)  { create :homestay }
  let!(:decorator) { HomestayDecorator.new(homestay) }

  describe "#geocoding_address" do
    context "address_suburb is nil" do
      before { homestay.address_suburb = nil }

      it "returns address_1, address_city, and address_country" do
        expected = "#{homestay.address_1}, #{homestay.address_city}, #{homestay.address_country}"

        expect(decorator.geocoding_address).to eq expected
      end
    end

    context "address_1 is nil" do
      before { homestay.address_1 = nil }

      it "returns address_suburb, address_city, and address_country" do
        expected = "#{homestay.address_suburb}, #{homestay.address_city}, #{homestay.address_country}"

        expect(decorator.geocoding_address).to eq expected
      end
    end

    context "address_suburb and address_1 is present" do
      before do
        homestay.address_1 = "test address_1"
        homestay.address_suburb = "test suburb"
      end

      it "returns address_1, address_suburb, address_city, and address_country" do
        expected = "#{homestay.address_1}, #{homestay.address_suburb}, #{homestay.address_city}, #{homestay.address_country}"
        expect(decorator.geocoding_address).to eq expected
      end
    end

    context "address_suburb and address_1 is nil" do
      before do
        homestay.address_1 = nil
        homestay.address_suburb = nil
      end

      it "returns address_city and address_country" do
        expected = "#{homestay.address_city}, #{homestay.address_country}"

        expect(decorator.geocoding_address).to eq expected
      end
    end
  end

  describe "#pretty_emergency_preparedness" do
    context "first_aid and emergency_transport are true" do
      before do
        homestay.first_aid = true
        homestay.emergency_transport = true
      end

      it { expect(decorator.pretty_emergency_preparedness).to eq "I know pet first-aid and can provide emergency transport" }
    end

    context "first_aid is true" do
      before do
        homestay.first_aid = true
        homestay.emergency_transport = false
      end

      it { expect(decorator.pretty_emergency_preparedness).to eq "I know pet first-aid" }
    end

    context "emergency_transport is true" do
      before do
        homestay.first_aid = false
        homestay.emergency_transport = true
      end

      it { expect(decorator.pretty_emergency_preparedness).to eq "I can provide emergency transport" }
    end
  end

  describe "#auto_decline_sms_text" do
    context "auto_decline_sms is present" do
      before { homestay.auto_decline_sms = "test auto_decline_sms" }

      it { expect(decorator.auto_decline_sms_text).to eq homestay.auto_decline_sms }
    end

    context "auto_decline_sms is nil" do
      before { homestay.auto_decline_sms = nil }

      it { expect(decorator.auto_decline_sms_text).to eq "Sorry - I can't help this time, but please ask again in the future!" }
    end

    context "auto_decline_sms is empty string" do
      before { homestay.auto_decline_sms = "" }

      it { expect(decorator.auto_decline_sms_text).to eq "Sorry - I can't help this time, but please ask again in the future!" }
    end
  end

  describe "#user_contact" do
    let!(:user) { homestay.user }

    context "user mobile is present" do
      before { homestay.user.mobile_number = "09270000000" }

      it "returns user mobile" do
        expect(decorator.user_contact).to eq user.mobile_number
      end
    end

    context "user mobile is blank" do
      before do
        homestay.user.mobile_number = nil
        homestay.user.email = "sample@pethomestay.com"
      end

      it "returns user email" do
        expect(decorator.user_contact).to eq user.email
      end
    end
  end

  describe "#auto_interest_sms_text" do
    context "auto_interest_sms is present" do
      before { homestay.auto_interest_sms = "test auto_interest_sms" }

      it { expect(decorator.auto_interest_sms_text).to eq homestay.auto_interest_sms }
    end

    shared_examples "returns auto_interest_sms_template with user_contact" do
      context "user mobile number is present" do
        before do
          homestay.user.mobile_number = "09277000000"
        end

        it { expect(decorator.auto_interest_sms_text).to eq "Hi, I would love to help look after your pet. Let's arrange a time to meet. My contact is 09277000000" }
      end

      context "user mobile is blank" do
        before do
          homestay.user.mobile_number = nil
          homestay.user.email = "sample@pethomestay.com"
        end

        it { expect(decorator.auto_interest_sms_text).to eq "Hi, I would love to help look after your pet. Let's arrange a time to meet. My contact is sample@pethomestay.com" }
      end
    end

    context "auto_interest_sms is nil" do
      before { homestay.auto_interest_sms = nil }

      it_behaves_like "returns auto_interest_sms_template with user_contact"
    end

    context "auto_interest_sms is empty string" do
      before { homestay.auto_interest_sms = "" }

      it_behaves_like "returns auto_interest_sms_template with user_contact"
    end
  end

  describe "#location" do
    context "address_suburb is not the same as address_city" do
      before do
        homestay.address_suburb = "test suburb"
        homestay.address_city = "test city"
      end

      it { expect(decorator.location).to eq "#{homestay.address_suburb}, #{homestay.address_city}" }
    end

    context "address_suburb is the same as address_city" do
      before do
        homestay.address_suburb = "test suburb"
        homestay.address_city = "test suburb"
      end

      it { expect(decorator.location).to eq "#{homestay.address_suburb}" }
    end
  end

  describe "#pretty_supervision" do
    context "constant_supervision is true" do
      before { homestay.constant_supervision = true }

      it { expect(decorator.pretty_supervision).to eq "I can provide 24/7 supervision for your pets" }
    end

    context "constant_supervision is true" do
      before do
        homestay.constant_supervision = false
        homestay.supervision_outside_work_hours = true
      end

      it { expect(decorator.pretty_supervision).to eq "I can provide supervision for your pets outside work hours (8am - 6pm)" }
    end
  end

  describe "#pretty_services" do
    context "pet_feeding is true" do
      before { homestay.pet_feeding = true }

      it { expect(decorator.pretty_services).to include "Pet feeding" }
    end

    context "pet_grooming is true" do
      before { homestay.pet_grooming = true }

      it { expect(decorator.pretty_services).to include "Pet grooming" }
    end

    context "pet_training is true" do
      before { homestay.pet_training = true }

      it { expect(decorator.pretty_services).to include "Pet training" }
    end

    context "pet_walking is true" do
      before { homestay.pet_walking = true }

      it { expect(decorator.pretty_services).to include "Pet walking" }
    end

    context "pet_feeding, pet_grooming, pet_training, and pet_walking are true" do
      before do
        homestay.pet_feeding  = true
        homestay.pet_grooming = true
        homestay.pet_walking  = true
        homestay.pet_training = true
      end

      it { expect(decorator.pretty_services).to eq "Pet feeding, pet grooming, pet training, and pet walking" }
    end
  end

end
