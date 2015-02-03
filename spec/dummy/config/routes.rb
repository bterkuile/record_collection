Rails.application.routes.draw do
  resources :employees

  batch_resources :employees
end
