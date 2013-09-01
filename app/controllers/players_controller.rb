class PlayersController < ApplicationController
  def new
    invitation = Invitation.find_by_uuid(params[:uuid]) || not_found
    @player = Player.new(email: invitation.email,
                         first_name: invitation.first_name,
                         last_name: invitation.last_name)
  end

  def create
    @player = Player.new(player_params)

    if @player.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def player_params
    params.require(:player).permit(:email, :password, :password_confirmation, :first_name, :last_name, :nickname)
  end
end
