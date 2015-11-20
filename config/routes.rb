Rails.application.routes.draw do

  devise_for :users, controllers: { passwords: 'passwords' }, skip: :sessions

  as :user do
    get 'login' => 'devise/sessions#new', as: :new_user_session
    post 'login' => 'devise/sessions#create', as: :user_session
    delete 'logout' => 'devise/sessions#destroy', as: :destroy_user_session
    get 'logout' => 'devise/sessions#destroy'
  end

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  # urls for admin only..
  admin_constraint = lambda do |request|
      request.env['warden'].authenticated? and request.env['warden'].user.has_role? :admin
  end

  resources :petitions do
    collection do
      get :all
      get :search
      get :manage

      constraints admin_constraint do
        get :admin
      end

      resources :desks, as: :petition_desks
    end

    resources :signatures, except: [:new, :show] do

      post :confirm_submit
      patch :confirm_submit

      collection do
        post :search

        get ':signature_id' => 'signatures#index', as: :anchor
      end
    end

    # resources :new_signatures
    resources :updates,  only: [:index, :show]

    get :finalize

    # is this used?
    get 'add_translation'
    patch 'update_owners'

  end

  resources :updates

  # resource :signatures

  root 'petitions#index'
  # STATIC PAGES

  %w(help about privacy donate contact profile).each do |name|
    get "/#{name}", to: "application##{name}"
  end

  post '/contact_submit', to: 'application#contact_submit'

  # dashboard statistics
  constraints admin_constraint do
      mount RedisAnalytics::Dashboard::Engine => "/visits"
      mount Sidekiq::Web => '/sidekiq'
  end

  #
  # make old links work
  #

  get '/signatures/:signature_id/confirm',    to: 'signatures#confirm', as: :signature_confirm
  get '/ondertekening/:signature_id/confirm', to: 'signatures#confirm'
  get '/petitie/:slug',       to: 'petitions#show'
  get '/resolve/:subdomain',  to: 'petitions#show'
end
