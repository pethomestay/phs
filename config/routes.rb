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

  resource :searches, only: [:create]

  authenticated do
    root to: "pages#home", :constraints => UserIsNotProvider
    root to: "pages#home", :constraints => UserIsProvider
  end

  unauthenticated do
    root to: "pages#home"
  end

  get '/how-it-works'         => 'pages#home', as: 'how_it_works'
  get '/why-pet-homestay'     => 'pages#home', as: 'why_pet_homestay'
  get '/contact'              => 'pages#home'
  get '/terms-and-conditions' => 'pages#home', as: 'terms_and_conditions'
  get '/privacy-policy'       => 'pages#home', as: 'privacy_policy'
end
