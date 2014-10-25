require 'spec_helper'

describe UserPicture, :type => :model do
  it { is_expected.to belong_to :picturable }
end