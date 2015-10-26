Rails.application.routes.draw do
  collection_resources :employees
  collection_resources :projects
  root to: 'dashboard#home'
end
