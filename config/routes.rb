Rails.application.routes.draw do
  devise_for :user, skip: [:registrations, :passwords], controllers: {
    sessions: 'public/sessions',
  }
  devise_scope :user do
    get 'user/sign_up', to: 'public/registrations#new', as: :new_user_registration
    post 'user', to: 'public/registrations#create', as: :user_registration
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root to: 'homes#top'
  get 'search' => 'searchs#search'

  scope module: :public do
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get 'potential_followers'
        get 'followings'
        get 'followers'
      end
    end
    resources :follow_requests, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
    resources :posts do
      resource :bookmarks, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :tweets do
      resource :favorites, only: [:create, :destroy]
    end
  end

  namespace :admin do
    resources :users, only: [:index, :edit, :update]
  end

end
