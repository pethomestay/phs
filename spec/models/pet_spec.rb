require 'spec_helper'

describe Pet do
  it { should belong_to :user }

  it { should have_many :pictures }

  it { should have_and_belong_to_many :enquiries }
end