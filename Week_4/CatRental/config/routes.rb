CatRental::Application.routes.draw do
  root :to => 'cats#index'


  get 'login', :to => "sessions#new", :as => :login
  post 'login', :to => "sessions#create"
  delete 'logout', :to => "sessions#destroy", :as => :logout

  resources :users, :except => [:index]
  #resources :session, :only => [:new, :create, :destroy]


  resources :cats do
    resources :rental_requests, :only => [:index]
  end
  resources :rental_requests, :except => [:index] do
    put "approve", :on => :member
    put "deny", :on => :member
  end
end
