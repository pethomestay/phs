PetHomestay::Application.routes.draw do

  devise_for :users, controllers: {registrations: "registrations"}

  resources :contacts, only: [:new, :create]
  resources :enquiries, only: [:create, :show, :update] do
    resource :confirmation, only: [:show, :update]
    resource :feedback
  end
  resources :homestays
  resources :pets, except: [:show]


  namespace :admin do
    match '/dashboard' => 'admin#dashboard', as: :admin_dashboard
    resources :enquiries
    resources :pets
    resources :users
  end

  get '/searches'       => 'searches#create'
  get '/pet-care/:city' => 'searches#show', as: 'city_search'

  get '/my-account'     => 'users#show', as: 'my_account'
  get '/my-account'     => 'users#show', as: 'user_root'
  root to: "pages#home"

  get '/searches/none'        => 'pages#home', as: 'no_results'
  get '/how-does-it-work'     => 'pages#how_does_it_work', as: 'how_does_it_work'
  get '/what-is'              => 'pages#about_us', as: 'what_is'
  get '/why-join-pethomestay' => 'pages#why_join_pethomestay', as: 'why_join'
  get '/blog'                 => 'pages#home'
  get '/terms-and-conditions' => 'pages#terms_and_conditions', as: 'terms_and_conditions'
  get '/house-rules'          => 'pages#house_rules', as: 'house_rules'
  get '/privacy-policy'       => 'pages#privacy_policy', as: 'privacy_policy'
  get '/faqs'                 => 'pages#faqs', as: 'faqs'
end
