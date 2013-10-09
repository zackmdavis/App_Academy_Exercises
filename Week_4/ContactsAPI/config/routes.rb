ContactsAPI::Application.routes.draw do

  resources :users, only: [] do
    resources :contacts, only: [:index] do
      get 'favorites', :on => :collection
    end
  end

  resources :contacts, except: [:new, :edit, :index]

  resources :users, except: [:new, :edit]

  resources :contact_shares, only: [:create, :destroy]

end
