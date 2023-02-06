Rails.application.routes.draw do
  get 'homes/index'
  root    'sessions#new'
  get     'login',    to: 'sessions#new'
  post    'login',    to: 'sessions#create'
  delete  'logout',   to: 'sessions#destroy'
  get     'signup',   to: 'users#new'
  get     'home',     to: 'homes#index'
  resources :users
end
