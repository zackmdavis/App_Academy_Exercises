FriendCircle::Application.routes.draw do

  root :to => "users#index"

  get 'login', :to => "sessions#new"
  post 'login', :to => "sessions#create"
  delete 'logout', :to => "sessions#destroy"

  resources :users

  resource :session, :only => [:new, :create, :destroy]

end
