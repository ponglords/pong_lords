class Api::V1::PlayersController < Api::V1::BaseController
  BATCH_SIZE = 20

  def index
    if params[:search]
      term = "%#{params[:search]}%"
      @players = Player.where("first_name ILIKE ? OR
                               last_name ILIKE ? OR
                               email ILIKE ? OR
                               nickname ILIKE ?", term, term, term, term)
    else
      @players = Player.order("created_at DESC").take(BATCH_SIZE)
    end
  end

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
