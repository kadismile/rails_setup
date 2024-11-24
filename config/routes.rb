Rails.application.routes.draw do
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  get '/about', to: 'home#about'

  scope '/users' do
    get '/sign_up', to: 'users#sign_up', as: :signup
    post '/register', to: 'users#create'
    get '/sign_in', to: 'users#sign_in', as: :sign_in
    post '/login', to: 'users#login'
    get '/logout', to: 'users#logout', as: 'logout'
  end
end
