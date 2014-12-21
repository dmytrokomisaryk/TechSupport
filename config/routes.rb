TechSupport::Application.routes.draw do
  devise_for :staffs
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'tickets#new'

  resources :tickets
end
