

describe UnavailableDate, :type => :model do

  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_uniqueness_of(:date).scoped_to(:user_id) }

  let(:user){ FactoryGirl.create(:confirmed_user) }
  let(:unavailable_date){ FactoryGirl.create(:unavailable_date, user: user) }

  context "date validation" do
    
    before do
      unavailable_date.date = Date.today - 1.day
    end

    it "should validate that date is not a past date" do
      expect(unavailable_date).to be_invalid
    end

    it "should add proper validation error message" do
      unavailable_date.save
      expect(unavailable_date.errors[:date].first).to eq(I18n.t("unavailable_date.invalid_date"))
    end

  end

  describe ".after_save" do
    it "should mark calendar as updated" do
      unavailable_date.save
      expect(unavailable_date.user.calendar_updated_at).to eq(Date.today)
    end
  end

  describe ".after_destroy" do
    it "should mark calendar as updated" do
      unavailable_date.save
      user.calendar_updated_at = Date.today - 1.day
      unavailable_date.destroy
      expect(unavailable_date.user.calendar_updated_at).to eq(Date.today)
    end
  end

end
