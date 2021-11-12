# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  resources :users

  resources :games, shallow: true do
    resources :players, shallow: true do
      resources :new_rounds
    end
    resources :rounds, shallow: true do
      resources :matching_rounds
      resources :completed_rounds
      resources :answer_swappers
      resources :answers
    end
  end

  resources :new_games, only: %i[new create]

  root "new_games#new"

  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?
end
