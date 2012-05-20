PetHomestay::Application.routes.draw do
  module UserIsNotProvider
    def self.matches?(request)
      if user = request.env['warden'].user
        !user.hotel && !user.sitter
      end
    end
  end

  module UserIsProvider
    def self.matches?(request)
      if user = request.env['warden'].user
        user.hotel || user.sitter
      end
    end
  end

  devise_for :users
  resource :hotel_steps

  resources :hotels
  resources :sitters

  resources :searches, only: [:create]

  authenticated do
    root to: "pages#home", :constraints => UserIsNotProvider
    root to: "pages#home", :constraints => UserIsProvider
  end

  unauthenticated do
    root to: "pages#home"
  end

  get '/how-it-works',          to: 'pages#how_it_works', as: 'how_it_works'
  get '/why-pet-homestay',      to: 'pages#why_pet_homestay', 
                                as: 'why_pet_homestay'
  get '/contact',               to: 'pages#contact'
  get '/terms-and-conditions',  to: 'pages#terms_and_conditions',
                                as: 'terms_and_conditions'
  get '/privacy-policy',        to: 'pages#privacy_policy',
                                as: 'privacy_policy'
end
