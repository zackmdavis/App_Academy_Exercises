CatRental::Application.routes.draw do
  root :to => 'cats#index'

  resources :cats do
    resources :rental_requests, :only => [:index]
  end
  resources :rental_requests, :except => [:index] do
    put "approve", :on => :member
    put "deny", :on => :member
  end
end
