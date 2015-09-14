require 'rails_helper'

RSpec.describe Repository::Duration do

  subject { Repository::Duration }

  describe ".all" do
    it {
      expected_titles = [
        "Morning",
        "Afternoon",
        "Evening",
        "Overnight",
        "2 nights",
        "3 nights",
        "4 nights",
        "5 nights",
        "6 nights",
        "7 nights",
        "Longer"
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }

    it {
      expected_naturals = [
        "the morning",
        "the afternoon",
        "the evening",
        "an overnight visit",
        "2 nights",
        "3 nights",
        "4 nights",
        "5 nights",
        "6 nights",
        "7 nights",
        "longer than 7 nights"
      ]

      expect(subject.all.map(&:natural)).to match_array expected_naturals
    }
  end

end
