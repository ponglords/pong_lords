class Api::V1::MatchesController < Api::V1::BaseController
  def create
    match = Match.new

    players = []
    params[:match][:players].each do |player|
      match.results.build(player: Player.find(player[:id]), won: player[:won])
    end

    match.results.each do |result|
      result.doubles_partner = match.results.select { |res| res.won == result.won }
                                            .reject { |res| res.player_id == result.player_id }
                                            .first.try(:player)
    end

    if match.save
      @players = match.players
      render :show
    else
      render json: { errors: match.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def match_params
    params.require(:match).permit(:players)
  end
end
