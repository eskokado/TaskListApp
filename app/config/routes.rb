# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :backoffice do
    get 'dashboard/index'

    resources :task_lists do
      resources :tasks, only: [:create, :update, :destroy]
    end

    resources :subscriptions, only: [:edit, :update]
  end

  root 'backoffice/dashboard#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
