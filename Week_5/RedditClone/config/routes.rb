RedditClone::Application.routes.draw do

  get 'login', :to => "sessions#new"
  post 'login', :to => "sessions#create"
  delete 'logout', :to => "sessions#destroy"

  resources :users

  resources :subs do
    resources :links
  end

  resources :comments

  root :to => "users#index"
end
