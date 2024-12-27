Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Health check
  get "/up", to: "application#up"

  scope module: "users" do
    resources :expenses, only: [:index, :create, :show, :edit, :update, :destroy]
    resources :expense_destroy, only: [:show]
    resources :monthly_expenses_breakdown, only: [:show], param: :date

    ### CUSTOM AUTHENTICATION ROUTES BELOW

    # Registration
    get "/sign_up", to: "registrations#new"
    post "/sign_up", to: "registrations#create"

    # Sessions
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    delete "/sessions/:id", to: "sessions#destroy", as: :destroy_user_session

    # Reset passwords
    get "/forgot-my-password", to: "reset_passwords#new"
    post "/forgot-my-password", to: "reset_passwords#create"
    get "/reset-my-password/:token", to: "reset_passwords#edit", as: :edit_reset_my_password
    patch "/reset-my-password/:token", to: "reset_passwords#update", as: :update_reset_my_password

    # Confirmation emails
    get "/users/confirmation", to: "confirmations#new"
    post "/users/confirmation", to: "confirmations#create"
    get "/users/confirmation/:token", to: "confirmations#edit", as: :edit_user_confirmation
    patch "/users/confirmation/:token", to: "confirmations#update", as: :update_user_confirmation

    get "/settings", to: "settings#edit"

    # Change emails
    patch "/settings/update_email", to: "settings#request_email_update", as: :user_request_email_update
    get "/settings/update_email/:token", to: "settings#update_email", as: :user_settings_update_email

    # Change passwords
    patch "/settings/passwords", to: "passwords#update", as: :update_user_password
  end

  root "root#index"
end
