require 'sidekiq/web'

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  constraints Clearance::Constraints::SignedIn.new do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :websites, only: [:index, :show, :create] 
   
  root "home#index"
end
