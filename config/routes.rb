OrderManagementSystem::Application.routes.draw do
  devise_for :users
  use_doorkeeper

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :products
      resources :orders, except: :destroy do
        resources :line_items
        resources :status_transitions, only: [:index, :create]
      end
    end
  end
end
