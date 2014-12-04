Rails.application.routes.draw do
  root to: "users#new"

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  resources :users, except: [:index, :destroy] do
    resources :contacts, except: [:index]
  end

  get '/session/new', to: redirect('/login')

  resource :session, only: [:new, :create, :destroy]

  match '/login'  => "sessions#new",     as: "login",  via: 'get'
  match '/logout' => "sessions#destroy", as: "logout", via: 'get'
end
