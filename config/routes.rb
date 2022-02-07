Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }
  devise_for :customers,skip: [:passwords, :registrations], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root to: 'homes#top'
  get 'about' => 'homes#about'
  get 'search' => 'searchs#search'

  scope module: :public do
    resource :customers, only: [:show, :edit, :update] do
      collection do
        patch 'delete'
        get 'confirm_delete'
      end
      resources :shipping_addresses, only: [:index, :edit ,:create, :update, :destroy]
      resources :cart_items, only: [:index, :create, :update, :destroy] do
        delete 'reset', on: :collection
      end
      resources :orders, only:[:new, :index, :show, :create] do
        collection do
          post 'confirm'
          get 'complete'
        end
      end
    end
    resources :items, only: [:index, :show]
  end

  namespace :admin do
    resources :users, only: [:index, :edit, :update]
  end

end
