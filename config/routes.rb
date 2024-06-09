Rails.application.routes.draw do
  devise_for :users
  root 'users#index'
  delete 'logout', to: 'users#destroy'
  resources :blogs
  
end
