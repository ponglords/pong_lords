require 'spec_helper'

describe PlayersController do
  describe "#new" do
    context "the invitation uuid exists" do
      before do
        @invitation = Invitation.create(email: "test@example.com", first_name: "First", last_name: "Last")
      end

      it "creates a new player based on an invitation" do
        get :new, uuid: @invitation.uuid

        assigns(:player).should_not be_nil
        assigns(:player).first_name.should eq("First")
        assigns(:player).last_name.should eq("Last")
        assigns(:player).email.should eq("test@example.com")
      end
    end

    context "the invitation uuid doesn't exist" do
      it "triggers a 404" do
        expect do
          get :new, uuid: "not-present-123"
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "#create" do
    context "the parameters are valid" do
      let(:parameters) do
        {
          player: {
            email: "test@example.com",
            first_name: "First",
            last_name: "Last",
            nickname: "",
            password: "abc123",
            password_confirmation: "abc123"
          }
        }
      end

      it "renders the show template" do
        post :create, parameters

        response.should redirect_to root_path
      end
    end

    context "the parameters are invalid" do
      let(:parameters) do
        {
          player: {
            email: "test@example.com",
            first_name: "First",
            last_name: "Last",
            nickname: "",
            password: "abc123",
            password_confirmation: "abc1234"
          }
        }
      end

      it "renders json with a list of errors" do
        post :create, parameters

        response.should render_template :new
      end
    end
  end
end
