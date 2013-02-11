require 'spec_helper'

describe Homestay do
  it { should belong_to :user }

  it { should have_many :enquiries }
  it { should have_many :pictures }

  it { should accept_nested_attributes_for :pictures }


end