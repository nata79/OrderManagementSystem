OrderManagementSystem::Application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :products
      resources :orders, except: :destroy
    end
  end
end
