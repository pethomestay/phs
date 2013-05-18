require 'spec_helper'

describe Homestay do
  it { should belong_to :user }

  it { should have_many :enquiries }
  it { should have_many :pictures }

  it { should accept_nested_attributes_for :pictures }

  it { should validate_presence_of :cost_per_night }
  it { should validate_presence_of :address_1}
  it { should validate_presence_of :address_suburb}
  it { should validate_presence_of :address_city}
  it { should validate_presence_of :address_country}
  it { should validate_presence_of :title}
  it { should validate_presence_of :description}
  it { should validate_uniqueness_of :slug }

  describe '#property_type_name' do
    subject { homestay.property_type_name }
    context 'when the Homestay has no property_type' do
      let(:homestay) { Homestay.new()}
      it 'should return nil' do
        subject.should be_nil
      end
    end
    context 'when the Homestay has a property_type' do
      let(:homestay) { Homestay.new(property_type_id: ReferenceData::PropertyType::HOUSE.id)}
      it 'should return the title of the property_type' do
        subject.should == ReferenceData::PropertyType::HOUSE.title
      end
    end
  end

  describe '#outdoor_area_name' do
    subject { homestay.outdoor_area_name }
    context 'when the Homestay has no outdoor_area' do
      let(:homestay) { Homestay.new()}
      it 'should return nil' do
        subject.should be_nil
      end
    end
    context 'when the Homestay has a outdoor_area' do
      let(:homestay) { Homestay.new(outdoor_area_id: ReferenceData::OutdoorArea::MEDIUM.id)}
      it 'should return the title of the outdoor_area' do
        subject.should == ReferenceData::OutdoorArea::MEDIUM.title
      end
    end
  end
end
