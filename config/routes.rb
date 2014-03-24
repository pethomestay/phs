PetHomestay::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations',  :omniauth_callbacks => 'users/omniauth_callbacks' }

  resources :contacts, only: [:new, :create]
  resources :enquiries, only: [:create, :show, :update] do
    resource :confirmation, only: [:show, :update]
    resource :feedbacks, only: [:new, :create]
  end
  resources :homestays do
	  member do
		  get 'favourite'
		  get 'non_favourite'
	  end

	  collection do
		  get 'favourites'
	  end
  end
  resources :transactions
  resources :pets, except: [:show]
  get '/welcome' => 'pages#welcome'
  post '/users/:id/unlink' => 'unlink#create', as: 'unlink'
  post '/homestays/:slug/rotate_image/:id' => 'homestays#rotate_image', as: 'rotate_homestay_image'

  resources :bookings do
	  collection do
		  post 'result'
		  get 'result'
		  get 'update_transaction'
		  get 'update_message'
		  get 'trips'
	  end
	  member do
		  get 'host_confirm'
		  get 'host_message'
		  get 'host_paid'
		  get 'admin_view'
	  end
  end

  resources :mailboxes, only: :index do
	  resources :messages, only: [:index, :create]
  end

  resources :accounts

  namespace :admin do
    match '/dashboard' => 'admin#dashboard', as: :dashboard
    resources :enquiries
    resources :bookings do
	    collection do
		    get :reconciliations_file
	    end
    end
    resources :transactions
    resources :feedbacks
    resources :homestays, except:[:new, :create]
    resources :pets
    resources :analytics
    resources :users
    resources :accounts
  end

  mount Ckeditor::Engine => '/ckeditor'

  get '/my-account'     => 'users#show', as: :my_account
  get '/my-account'     => 'users#show', as: :user_root

  get '/how-does-it-work'     => 'pages#how_does_it_work', as: 'how_does_it_work'
  get '/what-is'              => 'pages#about_us', as: 'what_is'
  get '/why-join-pethomestay' => 'pages#why_join_pethomestay', as: 'why_join'
  mount Blogit::Engine => '/blog'
  get '/terms-and-conditions' => 'pages#terms_and_conditions', as: 'terms_and_conditions'
  get '/house-rules'          => 'pages#house_rules', as: 'house_rules'
  get '/privacy-policy'       => 'pages#privacy_policy', as: 'privacy_policy'
  get '/faqs'                 => 'pages#faqs', as: 'faqs'
  get '/cancellation-policy'  => 'pages#cancellation_policy', as: 'cancellation_policy'
  get '/insurance-policy'     => 'pages#insurance_policy', as: 'insurance_policy'
  root to: 'pages#home'
end
