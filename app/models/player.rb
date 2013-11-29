class Player < ActiveRecord::Base
  PRO_RANKING = 2400
  STARTER_BOUNDRY = 5
  DEFAULT_RANKING = 1000

  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable,
         :token_authenticatable, :lockable

  has_many :results
  has_many :matches, through: :results

  scope :by_name, -> { order(:name) }
  scope :by_ranking, -> { order("ranking DESC") }
  scope :by_elo_with_diversity_index, -> { order("elo_with_diversity_index DESC") }
  scope :with_games, -> { joins(:results).where("players.id = results.player_id").distinct }

  def wins
    outcome_count(true)
  end

  def losses
    outcome_count(false)
  end

  private

  def outcome_count(win)
    results.where(won: win).count
  end
end
