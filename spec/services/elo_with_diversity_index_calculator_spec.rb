require 'spec_helper'

describe EloWithDiversityIndexCalculator do
  describe "#update_score" do
    let(:player) { FactoryGirl.create(:player, ranking: 50, diversity_index: 0) }


    context "the player is a begginer" do
      it "updates the score with the elo ranking times the default diversity index" do
        player.should_receive(:matches) { double(count: Player::STARTER_BOUNDRY - 1) }

        calculator = EloWithDiversityIndexCalculator.new(player, 150, 0)

        calculator.update_score

        player.elo_with_diversity_index.should eq (150 * EloWithDiversityIndexCalculator::STARTER_INDEX)
      end
    end

    context "the player is not a beginner" do
      it "returns the elo ranking times the diversity index" do
        player.should_receive(:matches) { double(count: Player::STARTER_BOUNDRY + 1) }

        calculator = EloWithDiversityIndexCalculator.new(player, 100, 0.9)

        calculator.update_score

        player.elo_with_diversity_index.should eq 90
      end
    end
  end
end
