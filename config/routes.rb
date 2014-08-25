PetHomestay::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations',  :omniauth_callbacks => 'users/omniauth_callbacks' }

  resources :users do
    collection do
      post :update_calendar
    end
  end

  resources :contacts, only: [:new, :create]
  resources :enquiries, only: [:create, :show, :update] do
    resource :confirmation, only: [:show, :update]
    resource :feedbacks, only: [:new, :create]
  end
  resources :homestays do
	  member do
		  get 'favourite'
		  get 'non_favourite'
      get 'availability'
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
  post '/homestays/:homestay_id/activate' => 'homestays#activate', as: 'homestay_activate'
  post '/admin/homestays/:homestay_id/locking' => 'admin/homestays#locking', as: 'admin_homestay_locking'
  post '/admin/bookings/:booking_id/host_cancel' => 'admin/bookings#host_cancel', as: 'admin_host_cancel_booking'
  post '/admin/bookings/:booking_id/guest_cancel' => 'admin/bookings#guest_cancel', as: 'admin_guest_cancel_booking'




  resources :bookings do
	  collection do
		  post 'result'
		  get 'result'
		  get 'update_transaction'
      get 'host_cancellation'
      post 'host_cancel'
		  get 'update_message'
		  get 'trips'
	  end
	  member do
		  get 'host_confirm'
      put 'book_reservation'
		  get 'host_message'
		  get 'host_paid'
      get 'guest_refunded'
      put 'host_confirm_cancellation'
      put 'guest_save_cancel_reason'
      get 'guest_cancelled'
		  get 'admin_view'
	  end
  end

  resources :mailboxes, only: :index do
	  resources :messages, only: [:index, :create]
  end

  resources :availability do
    collection do
      get :booking_info
    end
  end

  resources :unavailable_dates, :only => [:create, :destroy]

  resources :accounts do
    collection do
      post 'guest_cancel_save_account_details'
    end
  end

  namespace :admin do
    match '/dashboard' => 'admin#dashboard', as: :dashboard
    resources :enquiries
    resources :bookings do
	    collection do
		    get :reconciliations_file
      end
      member do
        post :reset_booking_state
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

  # Zendesk Single Sign-on
  get 'zendesk_session/:action', to: 'zendesk_session'

  mount Ckeditor::Engine => '/ckeditor'

  get '/my-account'     => 'users#show', as: :my_account
  get '/my-account'     => 'users#show', as: :user_root

  get '/how-does-it-work'     => 'pages#how_does_it_work', as: 'how_does_it_work'
  get '/the-team'             => 'pages#the_team', as: 'the_team'
  get '/why-join-pethomestay' => 'pages#why_join_pethomestay', as: 'why_join'
  mount Blogit::Engine => '/blog'
  get '/terms-and-conditions' => 'pages#terms_and_conditions', as: 'terms_and_conditions'
  get '/house-rules'          => 'pages#house_rules', as: 'house_rules'
  get '/privacy-policy'       => 'pages#privacy_policy', as: 'privacy_policy'
  get '/faqs'                 => 'pages#faqs', as: 'faqs'
  get '/cancellation-policy'  => 'pages#cancellation_policy', as: 'cancellation_policy'
  get '/insurance-policy'     => 'pages#insurance_policy', as: 'insurance_policy'
  get '/investors'            => 'pages#investors', as: 'investors'
  get '/legacy_home', to: 'pages#legacy_home', as: 'legacy_home'
  root to: 'pages#home'
end
