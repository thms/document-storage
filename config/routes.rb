Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  # Version 1 of the API:
  namespace :api do
    namespace :v1 do
      resources :documents do
        resources :versions
      end
    end
  end
end
