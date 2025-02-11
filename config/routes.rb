Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  concern :api_base do
    resources :blobs
    # resources :auth
  end

    namespace :api do
      namespace :v1 do
        concerns :api_base
        # Auth
        # post "auth/login", to: "auth#login"
        # post "auth/register", to: "auth#register"
        # post "auth/logout", to: "auth#logout"
        # post "blobs", to: "blobs#upload"
        # get "blobs/:id", to: "blobs#get"

        constraints Rodauth::Rails.authenticate do
          # Blobs
          post "blobs", to: "blobs#upload"
          get "blobs/:id", to: "blobs#get"
        end
    end
  end

  mount Rswag::Api::Engine => "api-docs"
  mount Rswag::Ui::Engine => "api-docs"
end
