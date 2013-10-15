StarlightMusic::Application.routes.draw do

  root :to => 'artists#index'

  get 'login', :to => "sessions#new"
  post 'login', :to => "sessions#create"
  delete 'logout', :to => 'sessions#destroy'

  resources :users

  resources :artists
  resources :albums
  resources :tracks, :only => [:show, :new, :create, :edit, :update, :destroy] do
    resources :notes, :only => [:new]
  end
  resources :notes, :only => [:create, :edit, :update, :destroy]

end
