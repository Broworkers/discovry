Rails.application.routes.draw do
  resources :searches
  root 'mockups#index'
end
