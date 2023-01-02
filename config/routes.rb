# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  resources :games, only: %i[show], shallow: true do
    resources :new_players, only: %i[create new]

    resources :players, only: %i[edit update], shallow: true do
      resources :turns, only: %i[create new]
    end

    resources :rounds, only: %i[show], shallow: true do
      resources :matching_rounds, only: %i[create]
      resources :completed_rounds, only: %i[create]
      resources :answer_swappers, only: %i[create]
      resources :participants, only: %i[], shallow: true do
        resources :answers, only: %i[create update]
      end
    end
  end

  resources :new_games, only: %i[create new]

  root "new_games#new"

  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?
end
