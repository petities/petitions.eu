Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)


  resources :petitions do
    collection do
      get :all
      get :search
    end

    resources :signatures, except: [:new] do
      post :confirm_submit
    end
    # resources :new_signatures

    resources :updates, only: [:index]


    get 'add_translation'
    patch 'update_owners'

  end

  resources :updates
  
  #resource :signatures

  root 'petitions#index'
  
  get '/signatures/:signature_key/confirm',    to: 'signatures#confirm'
  get '/ondertekening/:signature_key/confirm', to: 'signatures#confirm'
  get '/petitie/:slug',       to: 'petitions#show'
  get '/resolve/:subdomain',  to: 'petitions#show'
end
