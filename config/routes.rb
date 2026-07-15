Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resource :session, only: [ :new, :create, :destroy ]

  resource :direction, only: [ :show ], controller: "direction"

  namespace :crm do
    resources :leads, only: [ :index, :create ] do
      member { patch :move }
      collection { patch :quick_add }
    end
  end

  namespace :rh do
    resources :employees, only: [ :index ]
    resources :conge_requests, only: [] do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  namespace :studio do
    resources :projects, only: [ :index ] do
      member { patch :move }
    end
  end

  namespace :dev do
    resources :tickets, only: [ :index ] do
      member { patch :move }
    end
  end

  # Defines the root path route ("/")
  root "home#index"
end
