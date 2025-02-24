Rails.application.routes.draw do
  get 'compatible_responses/edit'
  get 'compatible_responses/update'
  get 'selected_prerequisites/edit'
  get 'selected_prerequisites/update'
  get 'selected_prerequisite/edit'
  get 'selected_prerequisite/update'
  get 'submissions/index'
  get 'submissions/show'
  get 'submissions/update'
  get 'submissions/create'
  get 'tenders/index'
  get 'tenders/show'
  get 'tenders/new'
  get 'tenders/update'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
