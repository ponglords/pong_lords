class Match < ActiveRecord::Base
  after_save :update_player_rankings

  has_many :results
  has_many :players, through: :results

  validate :player_count

  private

  def update_player_rankings
    results.each do |result|
      RankingCalculator.new(result, results.where(won: !result.won?).map(&:player), result.won?).update_ranking
      DiversityIndexCalculator.new(result.player).update_points
      EloWithDiversityIndexCalculator.new(result.player, result.player.ranking, result.player.diversity_index).update_score
    end
  end

  def player_count
    count = results.map(&:player).count
    errors.add(:base, "Invalid number of players") unless count == 2 || count == 4

    win_count = results.select(&:won).count
    loss_count = results.reject(&:won).count
    errors.add(:base, "Number of winners do not match the number of losers") unless win_count == loss_count
  end
end
