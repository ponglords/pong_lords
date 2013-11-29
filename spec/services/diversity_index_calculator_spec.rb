require 'spec_helper'

describe DiversityIndexCalculator do
  describe "#update_points" do
    context "player has played a lot of games" do
      before do
        losing_matches = FactoryGirl.create_list(:match, 2)
        winning_matches = FactoryGirl.create_list(:match, 7)

        losing_matches.each do |lm|
          losing_result = lm.results.where(won: false).first
          losing_result.player = player
          losing_result.save!
        end

        winning_matches.each do |wm|
          winning_result = wm.results.where(won: true).first
          winning_result.player = player
          winning_result.save!
        end
      end

      let(:player) { FactoryGirl.create(:player) }
      let(:losing_player) { FactoryGirl.create(:player) }

      it "changes the player's ranking" do
        calculator = DiversityIndexCalculator.new(player)

        calculator.update_points

        player.diversity_index.should be > 0
      end
    end

    context "player has only played one game" do
      before do
        winning_match = FactoryGirl.create(:match)
        winning_result = winning_match.results.where(won: true).first
        winning_result.player = player
        winning_result.save!
      end

      let(:player) { FactoryGirl.create(:player) }

      it "keeps the points at zero" do
        calculator = DiversityIndexCalculator.new(player)

        calculator.update_points

        player.diversity_index.should be == 0.0
      end
    end
  end
end
