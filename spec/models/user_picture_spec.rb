require 'spec_helper'

describe UserPicture do
  it { should belong_to :picturable }
end