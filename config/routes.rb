Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope module: "users" do
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

    get "/settings", to: "settings#index"
  end

  root "root#index"
end
