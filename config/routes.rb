Rails.application.routes.draw do
  resources :questions do
    member do
      post "approve"
      post "disapprove"
    end
  end
  devise_for :users
  root to: "questions#index"
end
