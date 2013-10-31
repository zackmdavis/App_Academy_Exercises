NewAuthDemo::Application.routes.draw do
  resources :users, :only => [:create, :new, :show]
  resources :pastes do
    resource :favorite
  end
  resources :favorites, :only => [:index]
  resource :session, :only => [:create, :destroy, :new]
  root :to => "root#root"
end
