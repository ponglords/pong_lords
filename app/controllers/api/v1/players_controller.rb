class Api::V1::PlayersController < Api::V1::BaseController
  def show
    @player = Player.find(params[:id])
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      render :show
    else
      render json: { errors: @player.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:email, :first_name, :last_name, :nickname, :password, :password_confirmation)
  end
end
