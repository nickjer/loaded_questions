# frozen_string_literal: true

Rails.application.routes.draw do
  root "games#index"

  resources :games
end
