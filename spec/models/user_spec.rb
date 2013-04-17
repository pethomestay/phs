require 'spec_helper'

describe User do

  it { should have_one :homestay }

  it { should have_many :pets }
  it { should have_many :enquiries }
  it { should have_many :given_feedbacks }
  it { should have_many :received_feedbacks }


  describe '#name' do
    it 'should concatenate first and last name' do
      User.new(first_name: 'Van', last_name: 'Halen').name.should == 'Van Halen'
    end
  end

  describe '#pet_name' do
    subject { user.pet_name }
    let(:user) { User.new }
    context 'when the user has multiple pets' do
      before { 2.times{user.pets << Pet.new(name: 'fred')} }
      it { should == 'your pets'}
    end
    context 'when the user has one pet' do
      before { user.pets << Pet.new(name: 'fred') }
      it 'should return the pets name' do
        subject.should == 'fred'
      end
    end
  end
end
