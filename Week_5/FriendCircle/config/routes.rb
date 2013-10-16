FriendCircle::Application.routes.draw do

  root :to => "users#index"

  get 'login', :to => "sessions#new"
  post 'login', :to => "sessions#create"
  delete 'logout', :to => "sessions#destroy"

  get 'users/passwordreset', :to => "users#password_reset"
  get 'users/:id/requestpasswordreset', :to => "users#request_password_reset"

  resources :users do
    resources :circles
  end

  resource :session, :only => [:new, :create, :destroy]

end
