Rails.application.routes.draw do
  root 'static_pages#index'
  post 'callback' => 'line_bot#callback'
end
