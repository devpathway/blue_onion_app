Rails.application.routes.draw do
  root "pages#index" # Loads React at the root path

  namespace :api do
    namespace :v1 do
      resources :journal_entries, only: [ :index ]
    end
  end
end
