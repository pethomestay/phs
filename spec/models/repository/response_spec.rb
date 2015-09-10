require 'rails_helper'

RSpec.describe Repository::Response do

  subject { Repository::Response }

  describe ".all" do
    it {
      expected_titles = [
        "None",
        "Accepted",
        "Undecided",
        "Declined",
        "Available",
        "Unavailable",
        "Question"
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }

    it {
      expected_descriptions = [
        "No Response",
        "I can do it",
        "I might be able to do it",
        "I can't do it",
        "Available",
        "Not available",
        "Have questions"
      ]

      expect(subject.all.map(&:description)).to match_array expected_descriptions
    }
  end

  describe ".find_by_ids" do
    it {
      expected_responses = [
        subject.find_by_id(1),
        subject.find_by_id(2),
        subject.find_by_id(3)
      ]

      expect(subject.find_by_ids([1, 2, 3])).to eq expected_responses
    }
  end
end
