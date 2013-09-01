PongLords::Application.routes.draw do
  api_version(module: "Api::V1", path: {:value => "v1"}, defaults: {:format => "json"}) do
    resources :players, only: [:show, :create]
    resources :invitations, only: [:create]
  end

  devise_for :players

  get '/players/:uuid/claim', to: 'players#new', as: 'invited_player_registration'
  post '/players', to: 'players#create', as: 'player_invitation_claim'

  root to: "home#index"
end
