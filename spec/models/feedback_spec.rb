require 'spec_helper'

describe Feedback do
  it { should belong_to :user }
  it { should belong_to :enquiry }
end