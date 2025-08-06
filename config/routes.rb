Rails.application.routes.draw do
  root 'home#index'
 
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
 
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
 
  resources :users, only: [:show, :edit, :update] do
    resources :addresses do
      member do
        patch :set_default
      end
    end
  end
 
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end
 
  resources :categories, only: [:show]
 
  # Cart routes
  get '/cart', to: 'cart#show'
  post '/cart/add/:product_id', to: 'cart#add_item', as: 'add_to_cart'
  patch '/cart/update/:product_id', to: 'cart#update_item', as: 'update_cart_item'
  delete '/cart/remove/:product_id', to: 'cart#remove_item', as: 'remove_from_cart'
  delete '/cart/clear', to: 'cart#clear', as: 'clear_cart'
 
  get '/checkout', to: 'checkout#show'
  post '/checkout', to: 'checkout#create'
 
  resources :orders, only: [:index, :show], param: :order_number
 
  get '/search', to: 'search#index'
 
  # Updated page routes - now dynamic
  get '/about', to: 'pages#show', defaults: { slug: 'about' }
  get '/contact', to: 'pages#show', defaults: { slug: 'contact' }
  get '/shipping', to: 'pages#show', defaults: { slug: 'shipping' }
  get '/returns', to: 'pages#show', defaults: { slug: 'returns' }
  
  # Generic route for additional pages
  get '/pages/:slug', to: 'pages#show', as: :page
 
  get '/astarr', to: 'products#index', defaults: { category: 'astarr' }
  get '/astarr-premium', to: 'products#index', defaults: { category: 'astarr-premium' }
 
  namespace :admin do
    root 'dashboard#index'
   
    resources :products do
      member do
        patch :toggle_active
        patch :toggle_featured
      end
    end
   
    resources :categories
    resources :orders, param: :order_number do
      member do
        patch :update_status
      end
    end
    resources :customers, only: [:index, :show]
    resources :reviews, only: [:index, :show, :destroy] do
      member do
        patch :approve
        patch :reject
      end
    end
    resources :tax_rates, only: [:index, :edit, :update]
    resources :site_contents, path: 'content'
    
    # Add pages management
    resources :pages, only: [:index, :show, :edit, :update], param: :slug
  end
 
  get '/health', to: proc { [200, {}, ['OK']] }
end