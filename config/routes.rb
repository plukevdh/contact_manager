Rails.application.routes.draw do
  resources :contacts
  namespace :api, defaults: { format: :json } do
    resources :contacts
  end

  root 'contacts#index'
end
