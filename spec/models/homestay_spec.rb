require 'rails_helper'

RSpec.describe Homestay, type: :model do

  subject { build :homestay }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }

    it { is_expected.to have_many(:enquiries) }
    it { is_expected.to have_many(:bookings) }
    it { is_expected.to have_many(:pictures) }
    it { is_expected.to have_many(:favourites) }
    it { is_expected.to have_many(:users).through(:favourites) }
    it { is_expected.to have_many(:unavailable_dates).through(:user) }
  end

  describe 'serialization' do
    it { is_expected.to serialize(:pet_sizes) }
    it { is_expected.to serialize(:favorite_breeds) }
    it { is_expected.to serialize(:energy_level_ids) }
  end

  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of :address_city }
      it { is_expected.to validate_presence_of :address_country }
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_presence_of :description }
      it { is_expected.to validate_presence_of :visits_price }
      it { is_expected.to validate_presence_of :visits_radius }
      it { is_expected.to validate_presence_of :delivery_price }
      it { is_expected.to validate_presence_of :delivery_radius }
    end

    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of :slug }
    end

    context 'length' do
      it { is_expected.to ensure_length_of(:title).is_at_most(50) }
    end

    context 'numericality' do
      it { is_expected.to validate_numericality_of(:supervision_id) }
      it { is_expected.to validate_numericality_of(:cost_per_night).is_greater_than_or_equal_to(10) }
      it { is_expected.to validate_numericality_of(:remote_price).is_greater_than_or_equal_to(0) }
      it { is_expected.to validate_numericality_of(:pet_walking_price).is_greater_than_or_equal_to(0) }
      it { is_expected.to validate_numericality_of(:pet_grooming_price).is_greater_than_or_equal_to(0) }

      it { is_expected.to validate_numericality_of(:visits_price).is_greater_than_or_equal_to(0) }
      it { is_expected.to validate_numericality_of(:visits_radius).is_greater_than_or_equal_to(0).only_integer }
      it { is_expected.to validate_numericality_of(:delivery_price).is_greater_than_or_equal_to(0) }
      it { is_expected.to validate_numericality_of(:delivery_radius).is_greater_than_or_equal_to(0).only_integer }
    end
  end

  describe 'nested attributes acceptance' do
    it { is_expected.to accept_nested_attributes_for(:pictures).allow_destroy(true) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:location).to(:decorator) }
    it { is_expected.to delegate_method(:geocoding_address).to(:decorator) }
    it { is_expected.to delegate_method(:auto_decline_sms_text).to(:decorator) }
    it { is_expected.to delegate_method(:auto_interest_sms_text).to(:decorator) }
    it { is_expected.to delegate_method(:pretty_emergency_preparedness).to(:decorator) }
  end

end
