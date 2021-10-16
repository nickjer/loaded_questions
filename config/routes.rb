# frozen_string_literal: true

Rails.application.routes.draw do
  resources :rounds
  resources :users
  root "games#index"

  resources :games
end
