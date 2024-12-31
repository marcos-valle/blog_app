Rails.application.routes.draw do
  devise_for :users, controllers: { 
  registrations: "users/registrations",
  sessions: "users/sessions"}
    resources :posts do
      resources :comments
    end
  
  #root "posts#index"
  


end
