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
end