PetHomestay::Application.routes.draw do
  devise_for :users

  resources :hotels
  resources :homestays

  get "search" => "search#create" # TODO: Remove this route
  resources :search, only: [:create]

  root to: "pages#home"
end
