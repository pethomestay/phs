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
end