class InvitationMailer < ActionMailer::Base
  default from: "noreply@ponglords.com"

  def invite_player(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: "You've been invited to join Pong Lords")
  end
end
