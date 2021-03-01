Rails.application.routes.draw do
  get "home/about" => "homes#about"
  root to: 'homes#top'
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update]
  resources :books do
    resource :favorites, only: [:create, :destroy]
  end
end
