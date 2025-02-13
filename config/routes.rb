Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  concern :api_base do
  end

  namespace :api do
    namespace :v1 do
      concerns :api_base
      post "auth/login", to: "auth#login", as: :login
      delete "auth/logout", to: "auth#logout", as: :logout
      post "auth/register", to: "auth#create_account", as: :register
      post "auth/refresh-token", to: "auth#refresh_token", as: :refresh_token
      constraints Rodauth::Rails.authenticate do
        # Blobs
        post "blobs", to: "blobs#upload"
        get "blobs/:key", to: "blobs#download"
      end
    end
  end
  mount OasRails::Engine => "/docs"
end
