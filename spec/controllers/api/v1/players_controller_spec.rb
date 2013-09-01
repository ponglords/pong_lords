require 'spec_helper'

describe Api::V1::PlayersController do
  describe "#show" do
    it "renders the show template" do
      Player.should_receive(:find).with("1")

      get :show, id: 1, format: :json

      response.should render_template :show
    end
  end

  describe "#create" do
    context "the parameters are valid" do
      let(:parameters) do
        {
          format: 'json',
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

        response.status.should eq(200)
        response.should render_template :show
      end
    end

    context "the parameters are invalid" do
      let(:parameters) do
        {
          format: 'json',
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

        response.status.should eq(422)
        error_list = JSON.parse(response.body)["errors"]
        error_list.length.should eq 1
        error_list.first =~ /Password confirmation does not match Password/
      end
    end
  end
end
