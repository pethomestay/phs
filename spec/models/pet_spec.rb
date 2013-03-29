require 'spec_helper'

describe Pet do
  it { should belong_to :user }

  it { should have_many :pictures }

  it { should have_and_belong_to_many :enquiries }

  describe '#sex_name' do
    subject { pet.sex_name }
    context 'when the Pet has no sex' do
      let(:pet) { Pet.new()}
      it 'should return nil' do
        subject.should be_nil
      end
    end
    context 'when the Pet has a sex' do
      let(:pet) { Pet.new(sex_id: ReferenceData::Sex::MALE_ENTIRE.id)}
      it 'should return the title of the sex' do
        subject.should == ReferenceData::Sex::MALE_ENTIRE.title
      end
    end
  end
end
