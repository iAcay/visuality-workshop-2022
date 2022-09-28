Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :articles, only: %i[index]
    end
  end
end
