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

end
