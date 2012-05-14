PetHomestay::Application.routes.draw do
  devise_for :users

  resources :hotels
  resources :homestays

  get "search" => "search#create" # TODO: Remove this route
  resources :search, only: [:create]

  root to: "pages#home"

  match '/how-it-works',  to: 'pages#how_it_works'
  match '/contact', to: 'pages#contact'
  match '/terms-and-conditions',  to: 'pages#terms_and_conditions'
  match '/privacy-policy',  to: 'pages#privacy_policy'
  get '/why-pet-homestay',      to: 'pages#why_pet_homestay', 
                                as: 'why_pet_homestay'
  
end
