Links::Application.routes.draw do

  get "/", :to => "links#index"

  resources :users
  resources :links
  resource :session


end
