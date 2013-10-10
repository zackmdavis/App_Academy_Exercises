CatRental::Application.routes.draw do
  resources :cats do
    resources :rental_requests, :only => [:index]
  end
  resources :rental_requests, :except => [:index]
end
