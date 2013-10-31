NewAuthDemo::Application.routes.draw do
  resources :users, :only => [:create, :new, :show]
  resources :pastes
  resource :session, :only => [:create, :destroy, :new]
  root :to => "root#root"
end
