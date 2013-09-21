require 'spec_helper'

describe Api::V1::SessionsController do
  describe "#create" do

    context "parameters are missing" do
      it "returns an error with a 422 status" do
        post :create, { player: { name: "Abc" }, format: :json }

        response.status.should eq 422
        JSON.parse(response.body)["errors"].should eq "Missing required parameters"
      end
    end

    context "required parameters are present" do
      context "the player doesn't exist" do
        it "returns an error with a 401 status" do
          post :create, { player: { email: "test@example.com", password: "password" }, format: :json }

          response.status.should eq 401
          JSON.parse(response.body)["errors"].should eq "The email and or password are not valid"
        end

        context "the player exists" do
          let(:password) { "password" }
          let(:email) { "test@example.com" }

          before do
            FactoryGirl.create(:player, email: email, password: password)
          end

          context "the password is not valid" do
            it "returns an error with a 401 status" do
              post :create, { player: { email: email, password: "wrong_password" }, format: :json }

              JSON.parse(response.body)["errors"].should eq "The email and or password are not valid"
            end
          end

          context "the password is valid" do
            it "renders the player's detail template" do
              post :create, { player: { email: email, password: password }, format: :json }

              response.status.should eq 200
              response.body.should render_template 'api/v1/players/show'
            end
          end
        end
      end
    end
  end
end
