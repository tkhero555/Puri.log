Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
  root 'static_pages#index'
  post 'callback' => 'line_bot#callback'
  resources :users, only: %i[show]
  resources :meals, only: %i[create]
end
