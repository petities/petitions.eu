Rails.application.routes.draw do
  get 'profile/edit'
  patch 'profile/patch'

  devise_for :users, controllers: { passwords: 'passwords' }, skip: :sessions

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

  constraints OfficeSubdomain do
    get '', to: 'desks#redirect'
  end

  resources :petitions do
    collection do
      get :all
      get :search
      get :manage

      constraints admin_constraint do
        get :admin, as: :petition_admin
      end

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

        get ':signature_id' => 'signatures#index', as: :anchor
      end
    end

    # resources :new_signatures
    resources :updates, only: [:index, :show]
    resource :export, only: :show

    get :finalize

    # is this used?
    # get 'add_translation'
    # patch 'update_owners'
  end

  resources :updates

  # resource :signatures

  root 'petitions#index'

  # STATIC PAGES
  constraints format: :html do
    PagesController::STATIC_PAGES.each do |name|
      get "/#{name}", to: "pages##{name}"
    end
  end

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

  # get '/signatures/:signature_id/becomeowner', to: 'signatures#become_petition_owner', as: :signature_become_owner
  get '/signatures/:signature_id/confirm', to: 'signatures#confirm', as: :signature_confirm

  get '/ondertekening/:signature_id', to: 'signatures#confirm'
  get '/ondertekening/:signature_id/confirm', to: 'signatures#confirm'

  get '/petitie/:id',         to: 'petitions#show'
  get '/resolve/:subdomain',  to: 'petitions#show'
end
