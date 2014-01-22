require 'spec_helper'

describe Pet do
  it { should belong_to :user }
  it { should have_many :pictures }
  it { should have_and_belong_to_many :enquiries }

  describe '#dislikes' do
    subject { pet.dislikes }
    context 'when the pet dislike_children is set' do
      let(:pet) { Pet.new( dislike_children: true) }
      it 'should contain Dislikes children' do
        subject.should =~ /Dislikes children/
      end
    end
    context 'when the pet dislike_children is not set' do
      let(:pet) { Pet.new( dislike_children: false) }
      it 'should contain Dislikes Children' do
        subject.should_not =~ /Dislikes children/
      end
    end
    context 'when the pet dislike_loneliness is set' do
      let(:pet) { Pet.new( dislike_loneliness: true) }
      it 'should contain Dislikes loneliness' do
        subject.should =~ /Dislikes being left alone/
      end
    end
    context 'when the pet dislike_loneliness is not set' do
      let(:pet) { Pet.new( dislike_loneliness: false) }
      it 'should contain Dislikes being left alone' do
        subject.should_not =~ /Dislikes being left alone/
      end
    end
    context 'when the pet dislike_people is set' do
      let(:pet) { Pet.new( dislike_people: true) }
      it 'should contain Dislikes people' do
        subject.should =~ /Dislikes strangers/
      end
    end
    context 'when the pet dislike_people is not set' do
      let(:pet) { Pet.new( dislike_people: false) }
      it 'should contain Dislikes strangers' do
        subject.should_not =~ /Dislikes strangers/
      end
    end
    context 'when the pet dislike_animals is set' do
      let(:pet) { Pet.new( dislike_animals: true) }
      it 'should contain Dislikes other animals' do
        subject.should =~ /Dislikes other animals/
      end
    end
    context 'when the pet dislike_animals is not set' do
      let(:pet) { Pet.new( dislike_animals: false) }
      it 'should contain Dislikes other animals' do
        subject.should_not =~ /Dislikes other animals/
      end
    end
  end

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
