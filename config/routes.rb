Rails.application.routes.draw do
  get 'users/new'
  devise_for :users
  get 'messages/index'
  root to: "messages#index"
  resources :users, only: [:edit , :update]

  
end
