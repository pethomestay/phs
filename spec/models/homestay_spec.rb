describe Homestay, :type => :model do

  it { is_expected.to belong_to :user }

  it { is_expected.to have_many :enquiries }
  it { is_expected.to have_many :pictures }

  it { is_expected.to accept_nested_attributes_for :pictures }

  it { is_expected.to validate_presence_of :cost_per_night }
  it { is_expected.to validate_presence_of :address_1}
  it { is_expected.to validate_presence_of :address_suburb}
  it { is_expected.to validate_presence_of :address_city}
  it { is_expected.to validate_presence_of :address_country}
  it { is_expected.to validate_presence_of :title}
  it { is_expected.to validate_presence_of :description}
  it { is_expected.to validate_uniqueness_of :slug }

  describe '#property_type_name' do
    subject { homestay.property_type_name }
    context 'when the Homestay has no property_type' do
      let(:homestay) { Homestay.new()}
      it 'should return nil' do
        expect(subject).to be_nil
      end
    end
    context 'when the Homestay has a property_type' do
      let(:homestay) { Homestay.new(property_type_id: ReferenceData::PropertyType::HOUSE.id)}
      it 'should return the title of the property_type' do
        expect(subject).to eq(ReferenceData::PropertyType::HOUSE.title)
      end
    end
  end

  describe '#outdoor_area_name' do
    subject { homestay.outdoor_area_name }
    context 'when the Homestay has no outdoor_area' do
      let(:homestay) { Homestay.new()}
      it 'should return nil' do
        expect(subject).to be_nil
      end
    end
    context 'when the Homestay has a outdoor_area' do
      let(:homestay) { Homestay.new(outdoor_area_id: ReferenceData::OutdoorArea::MEDIUM.id)}
      it 'should return the title of the outdoor_area' do
        expect(subject).to eq(ReferenceData::OutdoorArea::MEDIUM.title)
      end
    end
  end

  describe ".available_between" do

    let(:users){ 5.times.collect { FactoryGirl.create(:user_with_homestay) } }
    let(:homestays){ users.map(&:homestay) }
    let(:start_date){ Date.today }
    let(:end_date){ Date.today }

    subject{ homestays; Homestay.available_between(start_date, end_date).to_a }

    context "when none of the users have unavailalbe dates" do
      it "should return all homestays" do
        expect(subject).to eq(homestays)
      end
    end

    context "when a user is unavailable on one or more days between the passed dates" do
      it "should exlclude that user's home stay" do
        unavailable_user = users.first
        unavailable_user.unavailable_dates.create(date: Date.today)
        expect(subject).not_to include(unavailable_user.homestay)
      end
    end

    context "when every user is unavailable between one or more days between the passed dates" do
      
      let(:end_date){ Date.today + 2.day }

      it "should not return any homestays" do
        users.each { |user| user.unavailable_dates.create(date: (Date.today + 1)) }
        expect(subject).to be_blank
      end
    end
  end

  describe ".not_booked_between" do

    let(:users){ 5.times.collect { FactoryGirl.create(:user_with_homestay) } }
    let(:homestays){ users.map(&:homestay) }
    let(:booked_user){ users.last }
    let(:booking){ FactoryGirl.create(:booking, bookee: booked_user, check_in_date: check_in_date, check_out_date: check_out_date, state: :finished_host_accepted) }
    let(:start_date){ Date.today }
    let(:end_date){ start_date + 3.days }
    let(:check_in_date){ end_date + 1.day  }
    let(:check_out_date){ check_in_date + 100.days }

    subject{ homestays; booking; Homestay.not_booked_between(start_date, end_date).to_a }

    context "when none of the users are booked between start_date and end_date" do
      let(:booking){ "" }
      it "should return all homestays" do
        expect(subject & homestays).to match_array(homestays)
      end
    end

    context "when a user is  booked" do

      context "when check in date is less than start date and check out date is less than start date" do

        let(:check_in_date){ start_date - 2.days }
        let(:check_out_date){ start_date - 1.day }

        it "should include the user's homestay" do
          expect(subject).to include(booked_user.homestay)
          expect(subject.count).to eq(users.count)
        end
      end

      context "when check in date is less than start date and check out date is equal to start date" do
        
        let(:check_in_date){ start_date - 2.days }
        let(:check_out_date){ start_date }

        it "should not include the user's homestay" do
          expect(subject).to include(booked_user.homestay)
          expect(subject.count).to eq(users.count)
        end
      end

      context "when check in date is less than start date and check out date is greater start date" do

        let(:check_in_date){ start_date - 2.days }
        let(:check_out_date){ start_date + 1.day }

        it "should include the user's homestay" do
          expect(subject).not_to include(booked_user.homestay)
          expect(subject.count).to eq(users.count - 1)
        end
      end

      context "when check in date is equal to start date" do

        let(:check_in_date){ start_date }

        it "should return the user's homestay" do
          expect(subject).not_to include(booked_user.homestay)
          expect(subject.count).to eq(users.count - 1)
        end
      end

      context "when check in date is between start date and end date" do

        let(:check_in_date){ start_date + 1.day }

        it "should not return the user's homestay" do
          expect(subject).not_to include(booked_user.homestay)
          expect(subject.count).to eq(users.count - 1)
        end
      end

      context "when check in date is equal to end date" do

        let(:check_in_date){ end_date }

        it "should return the user's homestay" do
          expect(subject).not_to include(booked_user.homestay)
          expect(subject.count).to eq(users.count - 1)
        end
      end

      context "when check in date is greater than end date" do

        let(:check_in_date){ end_date + 1.day }

        it "should return the user's homestay" do
          expect(subject).to include(booked_user.homestay)
          expect(subject.count).to eq(users.count)
        end
      end

    end

  end

end
