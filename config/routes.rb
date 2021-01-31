Rails.application.routes.draw do
  get 'profile/edit'
  patch 'profile/patch'

  devise_for :users, skip: :sessions

  as :user do
    get 'login' => 'devise/sessions#new', as: :new_user_session
    get 'admin' => 'devise/sessions#new'
    post 'login' => 'devise/sessions#create', as: :user_session
    delete 'logout' => 'devise/sessions#destroy', as: :destroy_user_session
    get 'logout' => 'devise/sessions#destroy'
  end

  scope 'yesmaster' do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    get '/', to: 'admin/dashboard#index'
  end

  # urls for admin only..
  admin_constraint = lambda do |request|
    request.env['warden'].authenticated? && request.env['warden'].user.has_role?(:admin)
  end

  constraints PetitionSubdomain do
    get '', to: 'petitions#show'
  end

  constraints SubdomainConstraint do
    get '', to: 'subdomains#show'
  end

  resources :petitions do
    collection do
      get :all
      get :search
      get :manage

      resources :desks, as: :petition_desks
    end

    resources :signatures, except: [:new, :show] do
      post :confirm_submit
      patch :confirm_submit
      post :pledge_submit, as: :pledge_confirm
      patch :pledge_submit

      resources :invites, only: [:create]

      collection do
        post :search
        get :latest

        get ':signature_id' => 'signatures#index', as: :anchor
      end
    end

    # resources :new_signatures
    resources :updates, only: [:index, :show]
    resource :export, only: :show

    post :finalize
    post :release
  end

  resources :updates

  get '/dashboard', to: 'dashboard#show'

  root 'petitions#index'

  # STATIC PAGES
  constraints format: :html do
    PagesController::STATIC_PAGES.each do |name|
      get "/#{name}", to: "pages##{name}"
    end
  end

  get '/donate', to: 'donations#index'

  patch '/special_signature/:id', to: 'signatures#special_update', as: :special_signature

  get '/contact', to: 'contact#new', as: :contact
  post '/contact', to: 'contact#create'
  get '/contact/thanks', to: 'contact#thanks'

  # dashboard statistics
  constraints admin_constraint do
    mount RedisAnalytics::Dashboard::Engine => '/visits'
    mount Sidekiq::Web => '/sidekiq'
  end

  #
  # make old links work
  #

  get '/signatures/:signature_id/confirm', to: 'signatures#confirm', as: :signature_confirm

  get '/ondertekening/:signature_id', to: 'signatures#confirm'
  get '/ondertekening/:signature_id/confirm', to: 'signatures#confirm'

  get '/petitie/:id',         to: 'petitions#show'
  get '/resolve/:subdomain',  to: 'petitions#show'
end
