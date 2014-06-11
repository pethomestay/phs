require 'spec_helper'

describe ApplicationHelper do
  describe '#formatted_title' do
    subject {helper.formatted_title(title)}

    context 'when title is provided' do
      let(:title) { 'test title'}
      it 'should output the title plus - PetHomeStay' do
        subject.should == 'test title - PetHomeStay'
      end
    end

    context 'when title is not provided' do
      let(:title) { nil }
      it 'should just output PetHomeStay' do
        subject.should == 'PetHomeStay'
      end
    end
  end

  describe '#rating_stars' do
    before do
      helper.extend Haml
      helper.extend Haml::Helpers 
      helper.send :init_haml_helpers
    end

    it 'should output a number of i elements with the class icon-star equal to the rating' do
      (1..5).each do |rating|
        helper.capture_haml do
          helper.rating_stars rating 
        end.should have_selector('i', class: 'icon-star', count: rating)
      end
    end

    it 'should output a number of i elements with the class icon-star-empty equal to 5 minus the rating' do
      (1..5).each do |rating|
        helper.capture_haml do
          helper.rating_stars rating 
        end.should have_selector('i', class: 'icon-star-empty', count: (5 - rating))
      end
    end
  end

  describe '#date_day_month_year_format' do
    subject {helper.date_day_month_year_format(a_date)}

    context 'when date is provided' do
      let(:a_date) { Date.parse("2014-06-04")}
      it 'should output the date in the format (day/month/year) i.e. 04/06/2014' do
        subject.should == '04/06/2014'
      end
    end

    context 'when date is not provided and is nil' do
      let(:a_date) { nil}
      it 'should output an empty string' do
        subject.should == ''
      end
    end

    context 'when date is not provided and is a class other than a Date' do
      let(:a_date) { 4 }
      it 'should output an empty string' do
        subject.should == ''
      end
    end
  end

  describe '#date_day_monthname' do
    subject {helper.date_day_monthname(a_date)}

    context 'when date is provided' do
      let(:a_date) { Date.parse("2014-06-04")}
      it 'should output the date in the format (day month name) i.e. 04 June' do
        subject.should == '04 June'
      end
    end

    context 'when date is not provided and is nil' do
      let(:a_date) { nil}
      it 'should output an empty string' do
        subject.should == ''
      end
    end

    context 'when date is not provided and is a class other than a Date' do
      let(:a_date) { 4 }
      it 'should output an empty string' do
        subject.should == ''
      end
    end
  end


  describe '#hour_minute_format' do
    subject {helper.hour_minute_format(a_time)}

    context 'when time is provided' do
      let(:a_time) { Time.new(2014,6,4, 13,20,0, "+10:00")}
      it 'should output the time in the format (hour:minutes) i.e. 13:20' do
        subject.should == '13:20'
      end
    end

    context 'when time is not provided and is nil' do
      let(:a_time) { nil}
      it 'should output an empty string' do
        subject.should == ''
      end
    end

    context 'when time is not provided and is a class other than a Time' do
      let(:a_time) { 4 }
      it 'should output an empty string' do
        subject.should == ''
      end
    end
  end
end