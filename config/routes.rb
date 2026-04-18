Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  post "register", to: "auth#register"
  post "login", to: "auth#login"
  delete "logout", to: "auth#logout"

  get "me", to: "users#me"
  patch "update_me", to: "users#update_me"

  resources :tasks
  resources :users, only: [ :index, :update, :destroy ]
  # Defines the root path route ("/")
  root to: proc { [ 200, { "Content-Type" => "application/json" }, [ { message: "Todo API is live!" }.to_json ] ] }
end
