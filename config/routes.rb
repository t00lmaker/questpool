Rails.application.routes.draw do
  resources :questions
  devise_for :users
  root to: "welcome#index"
end
