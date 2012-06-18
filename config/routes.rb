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
  resource :login_dropdown, only: [:show]

  get '/test' => 'pages#test'

  resources :hotels do
    collection do
      resource :hotel_steps, path: 'sign-up', only: [:show, :update, :create, :destroy]
    end
    put 'rating' => 'ratings#update'
  end
  
  resources :sitters do
    collection do
      resource :sitter_steps, path: 'sign-up', only: [:show, :update, :create, :destroy]
    end
    put 'rating' => 'ratings#update'
  end

  get '/searches' => 'searches#create'

  authenticated do
    root to: "pages#home", :constraints => UserIsNotProvider
    root to: "pages#home", :constraints => UserIsProvider
  end

  unauthenticated do
    root to: "pages#home"
  end

  get '/searches/none'        => 'pages#home', as: 'no_results'
  get '/how-does-it-work'     => 'pages#home', as: 'how_does_it_work'
  get '/what-is'              => 'pages#home', as: 'what_is'
  get '/news'                 => 'pages#home'
  get '/contact'              => 'pages#home'
  get '/terms-and-conditions' => 'pages#home', as: 'terms_and_conditions'
  get '/privacy-policy'       => 'pages#home', as: 'privacy_policy'
end
