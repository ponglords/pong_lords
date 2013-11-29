require 'spec_helper'

describe Match do
  describe "after_save" do
    it "updates all of the player's ranking" do
      @match = FactoryGirl.create(:match)

      EloWithDiversityIndexCalculator.should_receive(:new).twice { double(update_score: nil) }

      @match.save!
    end
  end

  describe "before_save" do
    it "validates the number of players in the match" do
      @match = FactoryGirl.create(:match)
      @match.should be_valid

      @match.results << FactoryGirl.create(:result, won: false)
      @match.should_not be_valid
    end
  end
end
