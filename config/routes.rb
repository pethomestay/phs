PetHomestay::Application.routes.draw do
  devise_for :users
  resource :login_dropdown, only: [:show]

  get '/test' => 'pages#test'
  get '/welcome' => 'pages#welcome'

  resources :pets, except: [:show]
  resources :homestays do
    put 'rating' => 'ratings#update'
  end

  resources :enquiries, only: [:create, :show, :update] do
    resource :confirmation, only: [:show, :update]
    resource :rating
  end

  get '/searches'       => 'searches#create'
  get '/pet-care/:city' => 'searches#show', as: 'city_search'

  get '/my-account'     => 'users#show', as: 'my_account'
  root to: "pages#home"

  get '/searches/none'        => 'pages#home', as: 'no_results'
  get '/how-does-it-work'     => 'pages#home', as: 'how_does_it_work'
  get '/what-is'              => 'pages#home', as: 'what_is'
  get '/why-join-pethomestay' => 'pages#home', as: 'why_join'
  get '/blog'                 => 'pages#home'
  get '/contact'              => 'pages#home'
  get '/terms-and-conditions' => 'pages#home', as: 'terms_and_conditions'
  get '/house-rules'          => 'pages#home', as: 'house_rules'
  get '/privacy-policy'       => 'pages#home', as: 'privacy_policy'
  get '/faqs'                 => 'pages#home', as: 'faqs'
end
