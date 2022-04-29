Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    namespace :users do
      get '/', to: 'users#index', as: 'users_index'
      post '/', to: 'users#create', as: 'users_create'
      get '/:id', to: 'users#show', as: 'users_show'
      put '/:id', to: 'users#update', as: 'users_update'
      delete '/:id', to: 'users#destroy', as: 'users_delete'
    end
    namespace :sessions do
      get '/', to: 'sessions#index', as: 'sessions_index'
      post '/', to: 'sessions#create', as: 'sessions_create'
      get '/me', to: 'sessions#show', as: 'sessions_show'
      put '/', to: 'sessions#update', as: 'sessions_update'
      delete '/', to: 'sessions#destroy', as: 'sessions_destroy'
    end
  end
end
