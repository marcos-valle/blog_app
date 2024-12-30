Rails.application.routes.draw do
  devise_for :users
  root "posts#index" # Página inicial mostra os posts
  resources :posts do
    resources :comments, only: [:create] # Aninhe comentários em posts
  end
  # root "posts#index"
end
