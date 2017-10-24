Rails.application.routes.draw do
  resources :questions do
    member do
      get "approve"
      get "disapprove"
    end
  end
  devise_for :users
  root to: "questions#index"
end
