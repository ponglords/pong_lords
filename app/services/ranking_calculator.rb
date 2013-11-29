# Uses the Elo ranking system
# http://en.wikipedia.org/wiki/ELO_ranking
class RankingCalculator

  def initialize(result, opponents, won)
    @player = result.player
    @opponents = opponents
    @match_outcome = won ? 1 : 0
  end

  def update_ranking
    @player.ranking = (@player.ranking + change).to_i
    @player.reached_pro = true if @player.ranking >= Player::PRO_RANKING
    @player.save!
  end

  private

  def k_factor
    return 10 if @player.reached_pro?
    return 25 if @player.matches.count < Player::STARTER_BOUNDRY
    return 15
  end

  def probable_outcome
    1.0 / ( 1.0 + ( 10.0 ** ((opponent_avg_rating - @player.ranking) / 400.0 )))
  end

  def change
    k_factor * (@match_outcome - probable_outcome)
  end

  def opponent_avg_rating
    @opponents.map(&:ranking).sum / @opponents.count
  end
end
