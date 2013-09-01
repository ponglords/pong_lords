class Invitation < ActiveRecord::Base
  before_validation :set_uuid
  after_create :send_invitation_email

  validates_presence_of :uuid
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name

  validates_uniqueness_of :email
  validates_uniqueness_of :uuid

  private

  def set_uuid
    return unless self.uuid.blank?
    self.uuid = UUID.new.generate
  end

  def send_invitation_email
    InvitationMailer.invite_player(self).deliver
  end
end
