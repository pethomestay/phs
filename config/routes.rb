PetHomestay::Application.routes.draw do
  resources :hotels

  get "search" => "search#create" # TODO: Remove this route
  resources :search, only: [:create]

  root to: "pages#home"
end
