class Api::V1::SessionsController < Api::V1::BaseController

  before_filter :ensure_params_present, only: [:create]

  def create
    @player = Player.find_for_database_authentication(email: params[:player][:email])
    return invalid_authentication_attempt unless @player

    if @player.valid_password?(params[:player][:password])
      @player.ensure_authentication_token!
      return successful_authentication
    end

    invalid_authentication_attempt
  end

  private

  def ensure_params_present
    return unless params[:player].blank? || params[:player][:email].blank? || params[:player][:password].blank?
    render json: { errors: "Missing required parameters" }, status: :unprocessable_entity
  end

  def invalid_authentication_attempt
    render json: { errors: "The email and or password are not valid" }, status: :unauthorized
  end

  def successful_authentication
    render 'api/v1/players/show'
  end

end
