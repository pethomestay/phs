PetHomestay::Application.routes.draw do
  devise_for :users

  resources :hotels
  resources :sitters

  resources :searches, only: [:create]

  root to: "pages#home"

  get '/how-it-works',          to: 'pages#how_it_works', as: 'how_it_works'
  get '/why-pet-homestay',      to: 'pages#why_pet_homestay', 
                                as: 'why_pet_homestay'
  get '/contact',               to: 'pages#contact'
  get '/terms-and-conditions',  to: 'pages#terms_and_conditions',
                                as: 'terms_and_conditions'
  get '/privacy-policy',        to: 'pages#privacy_policy',
                                as: 'privacy_policy'
  
end
