PetHomestay::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations',  :omniauth_callbacks => 'users/omniauth_callbacks' }

  resources :users do
    collection do
      post :set_coupon
      post :decline_coupon
    end
  end

  resources :contacts, only: [:new, :create] do
    collection do
      post :add_note
    end
  end

  resources :enquiries, only: [:create, :show, :update] do
    resource :confirmation, only: [:show, :update]
    resource :feedbacks, only: [:new, :edit, :create]
    get "show_for_guest"
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
  resources :coupon_payouts, only: [:new, :update]
  resources :transactions
  get '/welcome' => 'pages#welcome'
  post '/users/:id/unlink' => 'unlink#create', as: 'unlink'
  post '/homestays/:homestay_id/activate' => 'homestays#activate', as: 'homestay_activate'
  post '/admin/homestays/:homestay_id/locking' => 'admin/homestays#locking', as: 'admin_homestay_locking'
  post '/admin/bookings/:booking_id/host_cancel' => 'admin/bookings#host_cancel', as: 'admin_host_cancel_booking'
  post '/admin/bookings/:booking_id/guest_cancel' => 'admin/bookings#guest_cancel', as: 'admin_guest_cancel_booking'

  resources :bookings do
    get 'host_cancellation'
    collection do
      post 'result'
      get 'result'
      get 'update_transaction'
      post 'host_cancel'
      get 'update_message'
    end
    post 'update_dates'
    get 'host_receipt'
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

  resources :unavailable_dates, :only => [:create, :destroy]

  resources :accounts do
    collection do
      post 'guest_cancel_save_account_details'
    end
  end

  namespace :guest do
    resources :messages, only: [:index, :create]
    resources :feedbacks, except: [:destroy]
    get '/calendar/availability', to: 'calendar#availability'
    post '/conversation/mark_read', to: 'messages#mark_read'
    resources :favorites, only: [:index]
    resources :pets, except: [:show]
    resource :account, only: [:new, :create, :edit, :update, :show]
    get '/',         to: 'guest#index'
  end
  devise_scope :user do
    get '/guest/edit', to: 'registrations#edit'
    get '/host/edit', to: 'registrations#edit'
  end

  namespace :host do
    get '/messages', to: 'messages#index'
    get '/calendar/availability', to: 'calendar#availability'
    get '/bookings', to: 'bookings#index'
    resources :feedbacks, except: [:destroy]
    resource :homestay, only: [:new, :create, :edit, :update]
    resource :account, only: [:new, :create, :edit, :update, :show]
    get '/',         to: 'host#index'
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
    resources :homestays, except:[:new, :create] do
      collection do
        get :by_date_created
      end
    end
    resources :pets
    resources :analytics
    resources :users
    resources :accounts, only: [:new, :create, :edit, :update, :destroy]
    resources :coupons, only: [:index] do
      post :create_coupon, :on => :collection
      post :expire_coupon, :on => :collection
    end
  end

  # Zendesk Single Sign-on
  get 'zendesk_session/:action', to: 'zendesk_session'

  mount Attachinary::Engine => "/attachinary"

  get '/guest-faq'            => redirect('http://support.pethomestay.com/hc/en-us/sections/200198489-Guest-FAQ'), as: 'guest_faq'
  get '/host-faq'             => redirect('http://support.pethomestay.com/hc/en-us/sections/200198479-Host-FAQ'), as: 'host_faq'
  get '/how-does-it-work'     => redirect('http://support.pethomestay.com/hc/en-us/articles/200678169-How-does-PetHomeStay-work-'), as: 'how_does_it_work'
  get '/the-team'             => 'pages#the_team', as: 'the_team'
  get '/why-join-pethomestay' => 'pages#why_join_pethomestay', as: 'why_join'
  match '/blog'               => redirect('http://blog.pethomestay.com'), as: 'blogit'
  get '/terms-and-conditions' => redirect('http://support.pethomestay.com/hc/en-us/articles/201214939-Terms-Conditions'), as: 'terms_and_conditions'
  get '/house-rules'          => redirect('http://support.pethomestay.com/hc/en-us/sections/200341999-House-Rules'), as: 'house_rules'
  get '/privacy-policy'       => redirect('http://support.pethomestay.com/hc/en-us/articles/201215089-Privacy-Policy'), as: 'privacy_policy'
  get '/cancellation-policy'  => redirect('http://support.pethomestay.com/hc/en-us/articles/202709609-Cancellation-Policy'), as: 'cancellation_policy'
  get '/charity-hosts'        => 'pages#charity_hosts', as: 'charity_hosts'
  get '/insurance-policy'     => 'pages#insurance_policy', as: 'insurance_policy'
  get '/investors'            => 'pages#investors', as: 'investors'
  get '/jobs'                 => 'pages#jobs', as: 'jobs'
  get '/partners'             => 'pages#partners', as: 'partners'
  get '/in-the-press'         => 'pages#in_the_press', as: 'press'
  get '/our-company'          => 'pages#our_company', as: 'our_company'

  # For SEO and Marketing
  get '/melbourne'  => redirect('/homestays/?search[location]=3000')
  get '/sydney'     => redirect('/homestays/?search[location]=2000')
  get '/brisbane'   => redirect('/homestays/?search[location]=4000')
  get '/adelaide'   => redirect('/homestays/?search[location]=5000')
  get '/gold_coast' => redirect('/homestays/?search[location]=4217')
  get '/perth'      => redirect('/homestays/?search[location]=6000')
  get '/darwin'     => redirect('/homestays/?search[location]=0800')
  get '/newcastle'  => redirect('/homestays/?search[location]=2300')

  # For legacy URLs
  get '/my-account/(*something)',   to: redirect('/guest')
  get '/mailboxes/(*something)',    to: redirect('/guest')
  get '/availability/(*something)', to: redirect('/host')

  # For SMSBroadcast inbound SMS requests
  get '/sms_receiver', :controller => :pages, :action => :receive_sms
  root to: 'pages#home'
end
