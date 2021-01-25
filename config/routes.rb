Rails.application.routes.draw do
  namespace :admin do
    resources :reviews
    get 'static_pages/home'
    get 'static_pages/help'
  end
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/signup', to: 'users#new'
  resources :users
  resources :books, only: :show
end

