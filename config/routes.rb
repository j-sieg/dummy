Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope module: "users" do
    get "/sign_up", to: "registrations#new"
    post "/sign_up", to: "registrations#create"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    delete "/sessions/:id", to: "sessions#destroy", as: :destroy_user_session

    get "/settings", to: "settings#index"
  end

  namespace :api do
    namespace :v1 do
      scope module: "users" do
        post "/login", to: "sessions#new"
        post "/logout", to: "sessions#destroy"
      end
    end
  end

  root "root#index"
end
