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
  post 'increment/card', to: 'static_pages#increment', as: 'increment'
  post 'decrement/card', to: 'static_pages#decrement', as: 'decrement'
  get 'terms', to: 'static_pages#terms'
  get 'policy', to: 'static_pages#policy'

  post 'callback' => 'line_bot#callback'

  resource :user, only: %i[show destroy] do
    collection do
      post :sort, as: 'sort_log'
      post :toggle_notifications
      post :accept_terms
    end
  end
  # stimulus_autocompleteの要求urlに合わせるために個別に設定
  get 'users/search', to: 'users#search'

  resources :meals, only: %i[create]
  resources :stools, only: %i[create destroy]
  resources :eatings, only: %i[destroy]
end
