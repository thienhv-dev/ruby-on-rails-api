Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    sign_up: 'register'
  }, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :posts
  resources :users, only: [:index, :show, :update, :destroy]
  post 'register' => 'users/registrations#create'
  get 'profile', to: 'users#profile'
  resources :users, only: [] do
    member do
      post :follow, to: 'users/follows#create'
      delete :unfollow, to: 'users/follows#destroy'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end