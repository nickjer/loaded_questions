# frozen_string_literal: true

Rails.application.routes.draw do
  resources :rounds
  resources :users
  resources :games
  resources :game_configurations, only: %i[new create]

  root "game_configurations#new"
end
