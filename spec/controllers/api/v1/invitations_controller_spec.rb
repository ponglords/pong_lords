require 'spec_helper'

describe Api::V1::InvitationsController do
  describe "#create" do
    context "the parameters are valid" do
      let(:parameters) do
        {
          format: 'json',
          invitation: {
            email: "test@example.com",
            first_name: "First",
            last_name: "Last"
          }
        }
      end

      it "renders the show template" do
        post :create, parameters

        response.status.should eq(200)
        response.should render_template :show
      end
    end

    context "the parameters are invalid" do
      let(:email) { "test@example" }
      let(:parameters) do
        {
          format: 'json',
          invitation: {
            email: email,
            first_name: "First",
            last_name: "Last"
          }
        }
      end

      before do
        FactoryGirl.create(:invitation, email: email)
      end

      it "renders json with a list of errors" do
        post :create, parameters

        response.status.should eq(422)
        error_list = JSON.parse(response.body)["errors"]
        error_list.length.should eq 1
        error_list.first =~ /Email is already taken/
      end
    end
  end
end
