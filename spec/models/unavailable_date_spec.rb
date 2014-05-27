require 'spec_helper'

describe UnavailableDate do

  it { should belong_to(:user) }
  it { should validate_presence_of(:date) }
  it { should validate_uniqueness_of(:date).scoped_to(:user_id) }

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
      time = Time.now
      Time.stub(:now).and_return(time)
      unavailable_date.save
      expect(unavailable_date.user.calendar_updated_at).to eq(time)
    end
  end

end
