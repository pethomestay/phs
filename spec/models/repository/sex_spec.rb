require 'rails_helper'

RSpec.describe Repository::Sex do

  subject { Repository::Sex }

  describe ".all" do
    it {
      expected_titles = [
        "Male desexed",
        "Female desexed",
        "Male entire",
        "Female entire"
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }
  end

end
