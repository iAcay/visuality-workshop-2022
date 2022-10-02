require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  
  namespace :api do
    namespace :v1 do
      resources :articles, only: %i[index create]
    end
  end
end
