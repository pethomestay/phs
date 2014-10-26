

describe Pet, :type => :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :pictures }
  it { is_expected.to have_and_belong_to_many :enquiries }

  describe '#dislikes' do
    subject { pet.dislikes }
    context 'when the pet dislike_children is set' do
      let(:pet) { Pet.new( dislike_children: true) }
      it 'should contain Dislikes children' do
        expect(subject).to match(/Dislikes children/)
      end
    end
    context 'when the pet dislike_children is not set' do
      let(:pet) { Pet.new( dislike_children: false) }
      it 'should contain Dislikes Children' do
        expect(subject).not_to match(/Dislikes children/)
      end
    end
    context 'when the pet dislike_loneliness is set' do
      let(:pet) { Pet.new( dislike_loneliness: true) }
      it 'should contain Dislikes loneliness' do
        expect(subject).to match(/Dislikes being left alone/)
      end
    end
    context 'when the pet dislike_loneliness is not set' do
      let(:pet) { Pet.new( dislike_loneliness: false) }
      it 'should contain Dislikes being left alone' do
        expect(subject).not_to match(/Dislikes being left alone/)
      end
    end
    context 'when the pet dislike_people is set' do
      let(:pet) { Pet.new( dislike_people: true) }
      it 'should contain Dislikes people' do
        expect(subject).to match(/Dislikes strangers/)
      end
    end
    context 'when the pet dislike_people is not set' do
      let(:pet) { Pet.new( dislike_people: false) }
      it 'should contain Dislikes strangers' do
        expect(subject).not_to match(/Dislikes strangers/)
      end
    end
    context 'when the pet dislike_animals is set' do
      let(:pet) { Pet.new( dislike_animals: true) }
      it 'should contain Dislikes other animals' do
        expect(subject).to match(/Dislikes other animals/)
      end
    end
    context 'when the pet dislike_animals is not set' do
      let(:pet) { Pet.new( dislike_animals: false) }
      it 'should contain Dislikes other animals' do
        expect(subject).not_to match(/Dislikes other animals/)
      end
    end
  end

  describe '#sex_name' do
    subject { pet.sex_name }
    context 'when the Pet has no sex' do
      let(:pet) { Pet.new()}
      it 'should return nil' do
        expect(subject).to be_nil
      end
    end
    context 'when the Pet has a sex' do
      let(:pet) { Pet.new(sex_id: ReferenceData::Sex::MALE_ENTIRE.id)}
      it 'should return the title of the sex' do
        expect(subject).to eq(ReferenceData::Sex::MALE_ENTIRE.title)
      end
    end
  end
end
