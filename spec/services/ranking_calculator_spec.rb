require 'spec_helper'

describe RankingCalculator do
  describe "#initialize" do
    let(:opponents) { [double] }

    context "the player won" do
      let(:player) { double(name: "Winner") }

      it "assigns the correct outcome" do
        calculator = RankingCalculator.new(double(player: player), opponents, true)
        calculator.instance_variable_get("@match_outcome").should eq 1
      end
    end

    context "the player lost" do
      let(:player) { double(name: "Loser") }

      it "assigns the correct outcome" do
        calculator = RankingCalculator.new(double(player: player), opponents, false)
        calculator.instance_variable_get("@match_outcome").should eq 0
      end
    end
  end

  describe "#update_ranking" do
    let(:opponents) { [stub_model(Player, ranking: 100)] }

    context "player is a pro" do
      let(:player) { double(name: "Player", ranking: 150, reached_pro?: true) }

      context "the player won" do
        it "increases the player's ranking" do
          calculator = RankingCalculator.new(double(player: player), opponents, true)

          player.should_receive(:ranking=).with(154)
          player.should_not_receive(:reached_pro=)
          player.should_receive(:save!)

          calculator.update_ranking
        end
      end

      context "the player lost" do
        it "decreases the player's ranking" do
          calculator = RankingCalculator.new(double(player: player), opponents, false)

          player.should_receive(:ranking=).with(144)
          player.should_not_receive(:reached_pro=)
          player.should_receive(:save!)

          calculator.update_ranking
        end
      end
    end

    context "the player just turned pro" do
      let(:opponents) { [stub_model(Player, ranking: Player::PRO_RANKING)] }
      let(:player) { stub_model(Player, name: "Player", ranking: (Player::PRO_RANKING - 1), reached_pro?: false) }

      it "flags the player as a pro" do
        calculator = RankingCalculator.new(double(player: player), opponents, true)

        player.should_receive(:matches) { double(count: 200) }
        player.should_receive(:reached_pro=).with(true)
        player.should_receive(:save!)

        calculator.update_ranking
      end
    end

    context "player is a starter" do
      let(:player) { double(name: "Player", ranking: 150, reached_pro?: false) }

      context "the player won" do
        it "increases the player's ranking" do
          calculator = RankingCalculator.new(double(player: player), opponents, true)

          player.should_receive(:matches) { double(count: 1) }
          player.should_receive(:ranking=).with(160)
          player.should_not_receive(:reached_pro=)
          player.should_receive(:save!)

          calculator.update_ranking
        end
      end

      context "the player lost" do
        it "decreases the player's ranking" do
          calculator = RankingCalculator.new(double(player: player), opponents, false)

          player.should_receive(:matches) { double(count: 1) }
          player.should_receive(:ranking=).with(135)
          player.should_not_receive(:reached_pro=)
          player.should_receive(:save!)

          calculator.update_ranking
        end
      end
    end
  end
end
