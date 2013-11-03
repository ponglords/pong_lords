require 'spec_helper'

describe Api::V1::PlayersController do
  render_views

  before :all do
    FactoryGirl.create(:player, email: "first_player@email.com", password: "password",
                       first_name: "John", last_name: "Doe", nickname: "Ace")
  end

  after :all do
    Player.find_by_email("first_player@email.com").destroy
  end

  describe "#index" do
    context "there are no search parameters" do
      it "returns a batch of the most recent players" do
        get :index, format: :json

        response.status.should eq(200)
        response.should render_template :index
        response.body.include?("first_player@email.com").should be_true
      end
    end

    context "there are search parameters" do
      context "parameter don't match any of the player's properties" do
        it "returns an empty list" do
          get :index, search: "no_matching_player", format: :json

          response.status.should eq(200)
          JSON.parse(response.body).should eq []
          response.should render_template :index
        end
      end

      context "parameter matches first name" do
        context "same case" do
          it "returns a list of players that have a first name that contains John" do
            get :index, search: "John", format: :json

            response.status.should eq(200)
            response.should render_template :index
            response.body.include?("first_player@email.com").should be_true
          end
        end

        context "different case" do
          it "returns a list of players that have a first name that contains John" do
            get :index, search: "jOhN", format: :json

            response.status.should eq(200)
            response.should render_template :index
            response.body.include?("first_player@email.com").should be_true
          end
        end
      end

      context "parameter matches last name" do
        context "same case" do
          it "returns a list of players that have a last name that contains Doe" do
            get :index, search: "Doe", format: :json

            response.status.should eq(200)
            response.should render_template :index
            response.body.include?("first_player@email.com").should be_true
          end
        end

        context "different case" do
          it "returns a list of players that have a last name that contains Doe" do
            get :index, search: "dOe", format: :json

            response.status.should eq(200)
            response.should render_template :index
            response.body.include?("first_player@email.com").should be_true
          end
        end
      end

      context "parameter matches email" do
        context "same case" do
          it "returns a list of players that have mail.com in their email address" do
            get :index, search: "mail.com", format: :json

            response.status.should eq(200)
            response.should render_template :index
            response.body.include?("first_player@email.com").should be_true
          end
        end

        context "different case" do
          it "returns a list of players that have mail.com in their email address" do
            get :index, search: "maIl.coM", format: :json

            response.status.should eq(200)
            response.should render_template :index
            response.body.include?("first_player@email.com").should be_true
          end
        end
      end

      context "parameter matches nickname" do
        context "same case" do
          it "returns a list of players that have Ace in their nickname" do
            get :index, search: "Ace", format: :json

            response.status.should eq(200)
            response.should render_template :index
            response.body.include?("first_player@email.com").should be_true
          end
        end

        context "different case" do
          it "returns a list of players that have Ace in their nickname" do
            get :index, search: "aCe", format: :json

            response.status.should eq(200)
            response.should render_template :index
            response.body.include?("first_player@email.com").should be_true
          end
        end
      end
    end
  end

  describe "#show" do
    it "renders the show template" do
      player = Player.find_by_email("first_player@email.com")

      get :show, id: player.id, format: :json

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
