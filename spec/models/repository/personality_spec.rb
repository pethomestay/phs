require 'rails_helper'

RSpec.describe Repository::Personality do

  subject { Repository::Personality }

  describe ".all" do
    it {
      expected_titles = [
        'Barker', 'Digger', 'Chewer', 'Playful', 'Energetic', 'Mellow', 'Smart',
        'Obedient', 'Mischievous', 'Loud', 'Quiet', 'Protective', 'Affectionate',
        'Crazy', 'Independent', 'Rowdy', 'Calm', 'Athletic', 'Lively', 'Happy',
        'Gentle'
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }
  end

end
