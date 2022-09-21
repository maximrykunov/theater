# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :shows, only: %i[create index destroy]
    end
  end

  get '/404' => 'errors#not_found'
  get '/500' => 'errors#exception'
end
