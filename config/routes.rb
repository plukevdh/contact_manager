Rails.application.routes.draw do
  resources :contacts, only: [:index]

  namespace :api, defaults: { format: :json } do
    resources :contacts, only: [:index, :create, :update]
  end

  root 'contacts#index'
end
