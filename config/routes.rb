Rails.application.routes.draw do
  get 'users/profiles', to: 'users#profiles', as: :top
  get 'users/sign_in', to: 'users#sign_in', as: :sign_in
  post '/users/sign_in', to: 'users#sign_in_process'
  get '/users/sign_out', to: 'users#sign_out', as: :sign_out
  get '/users/sign_up', to: 'users#sign_up', as: :sign_up

  
  get '/products', to: 'products#products', as: :products
  get '/products/new', to: 'products#new', as: :new
  get '/products/(:id)', to: 'products#show', as: :product
  get '/products/(:id)/like', to: 'products#like', as: :product_like
  get '/products/(:id)/edit', to: 'products#edit', as: :product_edit
  post '/products/(:id)/edit', to: 'products#update'
  post '/products', to: 'products#create'
  delete '/products/(:id)', to: 'products#destroy'

  
  get '/users/likes', to: 'users#likes', as: :likes
  get '/users/profiles/edit', to: 'users#edit', as: :profiles_edit
  post '/users/sign_up', to: 'users#sign_up_process'
  post '/users/profiles/edit', to: 'users#update'
  get '/', to: 'users#total', as: :total
  
  get 'markets/(:id)', to:'markets#item', as: :item
  get 'markets/(:id)/payment', to: 'markets#payment', as: :payment
  post 'markets/(:id)/payment', to: 'markets#purchase'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
