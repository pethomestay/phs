require 'rails_helper'

RSpec.describe Homestay, type: :model do

  subject { build :homestay }

  describe "associations" do
    it { is_expected.to belong_to(:user) }

    it { is_expected.to have_many(:enquiries) }
    it { is_expected.to have_many(:bookings) }
    it { is_expected.to have_many(:pictures) }
    it { is_expected.to have_many(:favourites) }
    it { is_expected.to have_many(:users).through(:favourites) }
    it { is_expected.to have_many(:unavailable_dates).through(:user) }
  end

  describe "serialization" do
    it { is_expected.to serialize(:pet_sizes) }
    it { is_expected.to serialize(:favorite_breeds) }
    it { is_expected.to serialize(:energy_level_ids) }
  end

  describe "validations" do
    context "presence" do
      it { is_expected.to validate_presence_of :address_city }
      it { is_expected.to validate_presence_of :address_country }
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_presence_of :description }
      it { is_expected.to validate_presence_of :visits_price }
      it { is_expected.to validate_presence_of :visits_radius }
      it { is_expected.to validate_presence_of :delivery_price }
      it { is_expected.to validate_presence_of :delivery_radius }
    end

    context "uniqueness" do
      it { is_expected.to validate_uniqueness_of :slug }
    end

    context "length" do
      it { is_expected.to ensure_length_of(:title).is_at_most(50) }
    end

    context "numericality" do
      describe "#supervision_id" do
        context "is present" do
          before { allow(subject).to receive(:supervision_id) { 1 } }

          it { is_expected.to validate_numericality_of(:supervision_id) }
        end

        context "is blank" do
          before { allow(subject).to receive(:supervision_id) { nil } }

          it { is_expected.to_not validate_numericality_of(:supervision_id) }
        end
      end

      describe "#cost_per_night" do
        context "is present" do
          before { allow(subject).to receive(:cost_per_night) { 1 } }

          it { is_expected.to validate_numericality_of(:cost_per_night).is_greater_than_or_equal_to(10) }
        end

        context "is blank" do
          before { allow(subject).to receive(:cost_per_night) { nil } }

          it { is_expected.to_not validate_numericality_of(:cost_per_night) }
        end
      end

      describe "#remote_price" do
        context "is present" do
          before { allow(subject).to receive(:remote_price) { 1 } }

          it { is_expected.to validate_numericality_of(:remote_price).is_greater_than_or_equal_to(0) }
        end

        context "is blank" do
          before { allow(subject).to receive(:remote_price) { nil } }

          it { is_expected.to_not validate_numericality_of(:remote_price) }
        end
      end

      describe "#pet_walking_price" do
        context "is present" do
          before { allow(subject).to receive(:pet_walking_price) { 1 } }

          it { is_expected.to validate_numericality_of(:pet_walking_price).is_greater_than_or_equal_to(0) }
        end

        context "is blank" do
          before { allow(subject).to receive(:pet_walking_price) { nil } }

          it { is_expected.to_not validate_numericality_of(:pet_walking_price) }
        end
      end

      describe "#pet_grooming_price" do
        context "is present" do
          before { allow(subject).to receive(:pet_grooming_price) { 1 } }

          it { is_expected.to validate_numericality_of(:pet_grooming_price).is_greater_than_or_equal_to(0) }
        end

        context "is blank" do
          before { allow(subject).to receive(:pet_grooming_price) { nil } }

          it { is_expected.to_not validate_numericality_of(:pet_grooming_price) }
        end
      end

      describe "#visits_price" do
        context "visits_radius is present" do
          before { allow(subject).to receive(:visits_radius) { 1 } }

          it { is_expected.to validate_numericality_of(:visits_price).is_greater_than_or_equal_to(0) }
        end

        context "visits_radius is blank" do
          before { allow(subject).to receive(:visits_radius) { nil } }

          it { is_expected.to_not validate_numericality_of(:visits_price) }
        end
      end

      describe "#visits_radius" do
        context "visits_price is present" do
          before { allow(subject).to receive(:visits_price) { 1 } }

          it { is_expected.to validate_numericality_of(:visits_radius).is_greater_than_or_equal_to(0).only_integer }
        end

        context "visits_price is blank" do
          before { allow(subject).to receive(:visits_price) { nil } }

          it { is_expected.to_not validate_numericality_of(:visits_radius) }
        end
      end

      describe "#delivery_price" do
        context "delivery_radius is present" do
          before { allow(subject).to receive(:delivery_radius) { 1 } }

          it { is_expected.to validate_numericality_of(:delivery_price).is_greater_than_or_equal_to(0) }
        end

        context "delivery_radius is blank" do
          before { allow(subject).to receive(:delivery_radius) { nil } }

          it { is_expected.to_not validate_numericality_of(:delivery_price) }
        end
      end

      describe "#delivery_radius" do
        context "delivery_price is present" do
          before { allow(subject).to receive(:delivery_price) { 1 } }

          it { is_expected.to validate_numericality_of(:delivery_radius).is_greater_than_or_equal_to(0).only_integer }
        end

        context "delivery_price is blank" do
          before { allow(subject).to receive(:delivery_price) { nil } }

          it { is_expected.to_not validate_numericality_of(:delivery_radius) }
        end
      end
    end
  end

  describe "nested attributes acceptance" do
    it { is_expected.to accept_nested_attributes_for(:pictures).allow_destroy(true) }
  end

  describe "delegations" do
    it { is_expected.to delegate_method(:location).to(:decorator) }
    it { is_expected.to delegate_method(:geocoding_address).to(:decorator) }
    it { is_expected.to delegate_method(:auto_decline_sms_text).to(:decorator) }
    it { is_expected.to delegate_method(:auto_interest_sms_text).to(:decorator) }
    it { is_expected.to delegate_method(:pretty_emergency_preparedness).to(:decorator) }
  end

  describe "scopes" do
    describe ".active" do
      let!(:active)   { create_list :homestay, 5, active: true }
      let!(:inactive) { create :homestay, active: false }

      it "returns active homestays" do
        expect(Homestay.active).to eq active
      end

      it "does not include inactive homestays" do
        expect(Homestay.active).to_not include inactive
      end
    end

    describe ".last_five" do
      let!(:first_five) { create_list :homestay, 5 }
      let!(:last_five)  { create_list :homestay, 5 }

      it "returns last 5 homestays in descending order" do
        expect(Homestay.last_five).to eq last_five.reverse
      end
    end
  end

  describe "callbacks" do
    context "before_save" do
      it { is_expected.to callback(:sanitize_description).before(:save) }
      it { is_expected.to callback(:strip_pet_sizes).before(:save) }
      it { is_expected.to callback(:strip_favorite_breeds).before(:save) }
      it { is_expected.to callback(:strip_energy_level_ids).before(:save) }
    end

    context "after_create" do
      it { is_expected.to callback(:notify_intercom).after(:create) }
    end

    context "after_initialize" do
      it { is_expected.to callback(:set_country_Australia).after(:initialize) }
    end

    context "before_validation" do
      it { is_expected.to callback(:set_slug).before(:validation) }
    end

    context "after_validation" do
      it { is_expected.to callback(:geocode).after(:validation) }
      it { is_expected.to callback(:copy_slug_errors_to_title).after(:validation) }
    end
  end

  describe "instance methods" do
    describe "#to_param" do
      it { expect(subject.to_param).to eq subject.slug }
    end

    describe "#emergency_preparedness?" do
      context "first_aid is true" do
        before { subject.first_aid = true }

        it { expect(subject.emergency_preparedness?).to eq true }
      end

      context "emergency_transport is true" do
        before { subject.emergency_transport = true }

        it { expect(subject.emergency_preparedness?).to eq true }
      end

      context "both first_aid and emergency_transport are false" do
        before do
          subject.emergency_transport = false
          subject.first_aid = false
        end

        it { expect(subject.emergency_preparedness?).to eq false }
      end
    end

    describe "#need_parental_constent?" do
      context "user is present" do
        before do
          subject.user = create :user
        end

        context "user has date of birth" do
          before { subject.user.date_of_birth = DateTime.current }

          context "date of birth is greater than 18 years" do
            before { subject.user.date_of_birth = DateTime.current - 19.years }

            it { expect(subject.need_parental_consent?).to eq false }
          end

          context "date of birth is less than 18 years" do
            before { subject.user.date_of_birth = DateTime.current - 17.years }

            it { expect(subject.need_parental_consent?).to eq true }
          end
        end

        context "user does not have date of birth" do
          before { subject.user.date_of_birth = nil }

          it { expect(subject.need_parental_consent?).to eq false }
        end
      end

      context "user is blank" do
        before { subject.user = nil }

        it { expect(subject.need_parental_consent?).to eq false }
      end
    end

    describe "#set_slug" do
      context "title is present" do
        before do
          subject.title = "test title"
          subject.slug  = nil
        end

        it "sets the slug with parameterized title" do
          expect { subject.set_slug }.to change { subject.slug }.from(nil).to("test-title")
        end
      end

      context "title is blank" do
        before do
          subject.title = nil
          subject.slug  = nil
        end

        it "does not set the slug" do
          expect { subject.set_slug }.to_not change { subject.slug }
        end
      end
    end

    describe "#average_rating" do
      context "user average_rating is 0" do
        before { subject.user.average_rating = 0 }

        it { expect(subject.average_rating).to eq 0 }
      end

      context "user average_rating is not zero" do
        before { subject.user.average_rating = 1 }

        it { expect(subject.average_rating).to eq 1 }
      end

      context "user average_rating is nil" do
        before { subject.user.average_rating = nil }

        it { expect(subject.average_rating).to eq 0 }
      end
    end

    describe "#inactive_listing?" do
      before do
        subject.active = false
        subject.locked = false
      end

      it "returns true when active and locked are false" do
        expect(subject.inactive_listing?).to eq true
      end
    end

    describe "#favourite?" do
      let!(:user)      { create :user }
      let!(:homestay)  { create :homestay }
      let(:favourite)  { create :favourite, user: user, homestay: homestay }

      context "with associated user_id and homestay_id" do
        before { favourite }

        it { expect(homestay.favourite?(user)).to eq true }
      end

      context "without associated user_id and homestay_id" do
        it { expect(homestay.favourite?(user)).to eq false }
      end
    end

    describe "#has_services?" do
      context "pet_feeding is true" do
        before { subject.pet_feeding = true }

        it { expect(subject.has_services?).to eq true }
      end

      context "pet_grooming is true" do
        before { subject.pet_grooming = true }

        it { expect(subject.has_services?).to eq true }
      end

      context "pet_training is true" do
        before { subject.pet_training = true }

        it { expect(subject.has_services?).to eq true }
      end

      context "pet_walking is true" do
        before { subject.pet_walking = true }

        it { expect(subject.has_services?).to eq true }
      end

      context "pet_feeding, pet_grooming, pet_training, and pet_walking are false" do
        before do
          subject.pet_feeding  = false
          subject.pet_grooming = false
          subject.pet_training = false
          subject.pet_walking  = false
        end

        it { expect(subject.has_services?).to eq false }
      end
    end

    describe "#energy_levels" do
      let(:energy_level_1) { ReferenceData::EnergyLevel.new(id: '1', title: "Low") }
      let(:energy_level_2) { ReferenceData::EnergyLevel.new(id: '2', title: "Low Medium") }

      before do
        subject.energy_level_ids = [energy_level_1.id, energy_level_2.id]
      end

      it "returns energy_levels associated with homestay" do
        # FIXME:
        # This should be returning the energy_level object, not the title attribute.
        expect(subject.energy_levels).to eq [energy_level_1.title, energy_level_2.title]
      end
    end

    describe "#sanitize_description" do
      before do
        subject.description = "Strippable tags <strong> description </strong> &nbsp;"
      end

      it "removes tags and nbsp of the description" do
        expect { subject.send(:sanitize_description) }.to change { subject.description }
          .from("Strippable tags <strong> description </strong> &nbsp;")
          .to("Strippable tags description")
      end
    end

    describe "#strip_pet_sizes" do
      before do
        subject.pet_sizes = ["test", ""]
      end

      it "removes blank entries" do
        expect { subject.send(:strip_pet_sizes) }.to change { subject.pet_sizes }
          .from(["test", ""])
          .to(["test"])
      end
    end

    describe "#strip_favorite_breeds" do
      before do
        subject.favorite_breeds = ["test", ""]
      end

      it "removes blank entries" do
        expect { subject.send(:strip_favorite_breeds) }.to change { subject.favorite_breeds }
          .from(["test", ""])
          .to(["test"])
      end
    end

    describe "#strip_energy_level_ids" do
      before do
        subject.energy_level_ids = ["test", ""]
      end

      it "removes blank entries" do
        expect { subject.send(:strip_energy_level_ids) }.to change { subject.energy_level_ids }
          .from(["test", ""])
          .to(["test"])
      end
    end

    describe "#set_country_Australia" do
      before do
        subject.address_country = ""
      end

      it "removes blank entries" do
        expect { subject.send(:set_country_Australia) }.to change { subject.address_country }
          .from("")
          .to("Australia")
      end
    end

    describe "#notify_intercom" do
      after { subject.notify_intercom }

      it { expect(Intercom::Event).to receive(:create) }
    end

    describe "#copy_slug_errors_to_title" do
      before do
        create :homestay, slug: "test"

        subject.slug = "test"
      end

      it { expect { subject.send(:copy_slug_errors_to_title) }.to change { subject.errors } }
    end
  end

end
