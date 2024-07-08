# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :backoffice do
    get 'dashboard/index'

    resources :task_lists do
      resources :tasks
    end

    resources :subscriptions, only: [:edit, :update]
  end

  root 'backoffice/task_lists#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
