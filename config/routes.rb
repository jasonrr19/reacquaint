Rails.application.routes.draw do

  devise_for :users
  root to: "pages#home"

  resources :tenders, only: [:index, :show, :new, :create, :edit, :update] do
    resources :submissions, only: [:index, :create]
  end

  resources :submissions, only: [:show, :update]

  resources :compatible_responses, only: [:edit, :update] do
    member do
      patch :write
      patch :score
    end
  end

  resources :selected_prerequisites, only: [:edit, :update] do
    member do
      patch :rewrite
      patch :analyse
    end
  end

  namespace :owner do
    resources :tenders, only: [:index]
  end

  namespace :bidder do
    resources :submissions, only: [:index]
  end

end
