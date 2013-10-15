FriendCircle::Application.routes.draw do

  get '/', :to => "users#index"

  resources :users

  resource :session, :only => [:new, :create, :destroy]

end
