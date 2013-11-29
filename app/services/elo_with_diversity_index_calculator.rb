# Combination of Elo and Diversity index algorithms
class EloWithDiversityIndexCalculator

  STARTER_INDEX = 0.5

  def initialize(player, elo_ranking, diversity_index)
    @player = player
    @elo_ranking = elo_ranking
    @diversity_index = diversity_index
  end

  def update_score
    @player.elo_with_diversity_index = new_score
    @player.save!
  end

  private

  def new_score
    index = @player.matches.count < Player::STARTER_BOUNDRY ? STARTER_INDEX : @diversity_index

    (@elo_ranking * index).round(2)
  end
end
