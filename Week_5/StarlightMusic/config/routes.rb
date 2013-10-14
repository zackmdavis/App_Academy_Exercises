StarlightMusic::Application.routes.draw do

  root :to => 'artists#index'

  get 'login', :to => "sessions#new"
  post 'login', :to => "sessions#create"
  delete 'logout', :to => 'sessions#destroy'

  resources :users

  resources :artists do
    resources :albums, :only => [:index, :new, :create]
    resources :tracks, :only => [:index]
  end
  resources :albums, :only => [:show, :edit, :update, :destroy] do
    resources :tracks, :only => [:new, :create]
  end
  resources :tracks, :only => [:show, :edit, :update, :destroy]

end
