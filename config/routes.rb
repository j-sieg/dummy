Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :users do
    # Registration
    get "/sign_up", to: "registrations#new"
    post "/sign_up", to: "registrations#create"

    # Sessions
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    delete "/sessions/:id", to: "sessions#destroy", as: :destroy_session

    # Reset passwords
    get "/forgot-my-password", to: "reset_passwords#new"
    post "/forgot-my-password", to: "reset_passwords#create"
    get "/reset-my-password/:token", to: "reset_passwords#edit", as: :edit_reset_my_password
    patch "/reset-my-password/:token", to: "reset_passwords#update", as: :update_reset_my_password

    # Confirmation emails
    get "confirmation", to: "confirmations#new"
    post "confirmation", to: "confirmations#create"
    get "confirmation/:token", to: "confirmations#edit", as: :confirmation_edit
    patch "confirmation/:token", to: "confirmations#update", as: :confirmation_update

    get "/settings", to: "settings#edit"

    # Change emails
    patch "/settings/update_email", to: "settings#request_email_update", as: :settings_request_email_update
    get "/settings/update_email/:token", to: "settings#update_email", as: :settings_update_email

    # Change passwords
    patch "/settings/passwords", to: "passwords#update"
  end

  root "root#index"
end
