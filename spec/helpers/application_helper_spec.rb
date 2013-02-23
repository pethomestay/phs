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
end