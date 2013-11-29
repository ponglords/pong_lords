require 'spec_helper'

describe Api::V1::MatchesController do
  describe "#create" do
    context "the parameters are valid" do
      context "singles match" do
        let(:player_1) { FactoryGirl.create(Player) }
        let(:player_2) { FactoryGirl.create(Player) }

        let(:parameters) do
          {
            format: 'json',
            match: {
              players: [
                { id: 1, won: true },
                { id: 2, won: false }
              ]
            }
          }
        end

        it "renders the show template" do
          Player.should_receive(:find).with(1) { player_1 }
          Player.should_receive(:find).with(2) { player_2 }

          post :create, parameters

          response.status.should eq(200)
          response.should render_template :show

          player_1.results.first.doubles_partner.should be_nil
          player_2.results.first.doubles_partner.should be_nil
        end
      end

      context "doubles match" do
        let(:player_1) { FactoryGirl.create(Player) }
        let(:player_2) { FactoryGirl.create(Player) }
        let(:player_3) { FactoryGirl.create(Player) }
        let(:player_4) { FactoryGirl.create(Player) }

        let(:parameters) do
          {
            format: 'json',
            match: {
              players: [
                { id: 1, won: true },
                { id: 3, won: true },
                { id: 4, won: false },
                { id: 2, won: false }
              ]
            }
          }
        end

        it "renders the show template" do
          Player.should_receive(:find).with(1) { player_1 }
          Player.should_receive(:find).with(2) { player_2 }
          Player.should_receive(:find).with(3) { player_3 }
          Player.should_receive(:find).with(4) { player_4 }

          post :create, parameters

          response.status.should eq(200)
          response.should render_template :show

          player_1.results.first.doubles_partner.should eq player_3
          player_3.results.first.doubles_partner.should eq player_1
          player_4.results.first.doubles_partner.should eq player_2
          player_2.results.first.doubles_partner.should eq player_4
        end
      end
    end

    context "the number of losers are invalid" do
      let(:email) { "test@example" }
      let(:parameters) do
        {
          format: 'json',
          match: {
            players: [
              { id: 1, won: true }
            ]
          }
        }
      end

      it "renders json with a list of errors" do
        Player.should_receive(:find).with(1) { FactoryGirl.create(Player, ranking: 10) }

        post :create, parameters

        response.status.should eq(422)
        error_list = JSON.parse(response.body)["errors"]
        error_list.length.should eq 2
        error_list.should include("Invalid number of players")
        error_list.should include("Number of winners do not match the number of losers")
      end
    end

    context "the number of winners are invalid" do
      let(:email) { "test@example" }
      let(:parameters) do
        {
          format: 'json',
          match: {
            players: [
              { id: 1, won: true },
              { id: 2, won: true }
            ]
          }
        }
      end

      it "renders json with a list of errors" do
        Player.should_receive(:find).with(1) { FactoryGirl.create(Player, ranking: 10) }
        Player.should_receive(:find).with(2) { FactoryGirl.create(Player, ranking: 15) }

        post :create, parameters

        response.status.should eq(422)
        error_list = JSON.parse(response.body)["errors"]
        error_list.length.should eq 1
        error_list.should include("Number of winners do not match the number of losers")
      end
    end
  end
end
