class Api::V1::InvitationsController < Api::V1::BaseController
  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      render :show
    else
      render json: { errors: @invitation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email, :first_name, :last_name)
  end
end
