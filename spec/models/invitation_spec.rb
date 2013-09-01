require 'spec_helper'

describe Invitation do
  it "assigns a uuid to each new invitation" do
    invitation = Invitation.create(email: "test@example.com")

    invitation.uuid.should_not be_blank
  end
end
