require 'spec_helper'

describe User do

  it { should have_one :homestay }

  it { should have_many :pets }
  it { should have_many :enquiries }
  it { should have_many :given_feedbacks }
  it { should have_many :received_feedbacks }
  
end