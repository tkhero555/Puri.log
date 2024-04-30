Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    sessions: 'users/sessions'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    post 'users/guest_logged_sign_in', to: 'users/sessions#guest_logged_sign_in'
  end
  root 'static_pages#index'
  post 'callback' => 'line_bot#callback'
  resources :users, only: %i[show]
  resources :meals, only: %i[create]
  resources :stools, only: %i[create destroy]
  resources :eatings, only: %i[destroy]
end
