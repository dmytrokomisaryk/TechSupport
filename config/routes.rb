TechSupport::Application.routes.draw do
  devise_for :staffs
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticated :staff do
    root to: 'tickets#unassigned', as: :authenticated
  end

  root to: 'tickets#new'

  resources :tickets do
    member do
      post :answer
      post :close
      post :assign
      post :reply
      get :successfully_created
    end
    collection do
      get '/by_email/:email', action: 'by_email', as: 'by_email', constraints: { email: /[^\/]+/ }
      post :search
    end
  end
end
