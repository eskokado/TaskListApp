# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :backoffice do
    get 'dashboard/index'
  end
  root 'backoffice/dashboard#index'
end
