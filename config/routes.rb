# frozen_string_literal: true

Rails.application.routes.draw do
  resources :answers
  resources :users

  resources :games, shallow: true do
    resources :players, shallow: true do
      resources :rounds
    end
  end

  resources :game_configurations, only: %i[new create]

  root "game_configurations#new"
end
