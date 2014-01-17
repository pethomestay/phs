PetHomestay::Application.routes.draw do

  devise_for :users, controllers: {registrations: "registrations"}

  resources :contacts, only: [:new, :create]
  resources :enquiries, only: [:create, :show, :update] do
    resource :confirmation, only: [:show, :update]
    resource :feedbacks, only: [:new, :create]
  end
  resources :homestays
  resources :pets, except: [:show]
  get '/welcome' => 'pages#welcome'

  resources :bookings do
	  collection do
		  post 'result'
		  get 'result'
		  get 'update_transaction'
		  get 'update_booking'
	  end
	  member do
		  get 'host_confirm'
	  end
  end


  namespace :admin do
    match '/dashboard' => 'admin#dashboard', as: :dashboard
    resources :enquiries
    resources :feedbacks
    resources :homestays, except:[:new, :create]
    resources :pets
    resources :users
  end

  get '/my-account'     => 'users#show', as: :my_account
  get '/my-account'     => 'users#show', as: :user_root

  get '/how-does-it-work'     => 'pages#how_does_it_work', as: 'how_does_it_work'
  get '/what-is'              => 'pages#about_us', as: 'what_is'
  get '/why-join-pethomestay' => 'pages#why_join_pethomestay', as: 'why_join'
  #get '/blog'                 => 'pages#home'
  mount Blogit::Engine => "/blog"
  get '/terms-and-conditions' => 'pages#terms_and_conditions', as: 'terms_and_conditions'
  get '/house-rules'          => 'pages#house_rules', as: 'house_rules'
  get '/privacy-policy'       => 'pages#privacy_policy', as: 'privacy_policy'
  get '/faqs'                 => 'pages#faqs', as: 'faqs'
  root to: "pages#home"
end
