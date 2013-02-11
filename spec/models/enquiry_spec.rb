require 'spec_helper'

describe Enquiry do
   it { should belong_to :user }
   it { should belong_to :homestay }

   it { should have_many :feedbacks }
   it { should have_and_belong_to_many :pets }
end