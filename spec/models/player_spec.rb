require 'spec_helper'

describe Player do
  describe "#wins" do
    it "returns the number of results where the player has won" do
      player = FactoryGirl.create(:player)
      matches = FactoryGirl.create_list(:match, 5)

      matches.each do |m|
        winning_result = m.results.where(won: true).first
        winning_result.player = player
        winning_result.save!
      end

      player.wins.should eq 5
    end
  end

  describe "#losses" do
    it "returns the number of results where the player has lost" do
      player = FactoryGirl.create(:player)
      matches = FactoryGirl.create_list(:match, 3)

      matches.each do |m|
        losing_result = m.results.where(won: false).first
        losing_result.player = player
        losing_result.save!
      end

      player.losses.should eq 3
    end
  end
end
