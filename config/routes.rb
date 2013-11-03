PongLords::Application.routes.draw do
  api_version(module: "Api::V1", path: {:value => "v1"}, defaults: {:format => "json"}) do
    resources :players, only: [:index, :show, :create]
    resources :invitations, only: [:create]

    post :sign_in, to: 'sessions#create', as: :sign_in
  end

  devise_for :players

  get '/players/:uuid/claim', to: 'players#new', as: 'invited_player_registration'
  post '/players', to: 'players#create', as: 'player_invitation_claim'

  get 'thanks', to: 'static#thanks'

  root to: "home#index"
end
