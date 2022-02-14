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

  get 'search_page' => 'homes#search_page'
  get 'search' => 'searches#search'

  scope module: :public do
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get 'potential_followers'
        get 'followings'
        get 'followers'
        get 'bookmarks'
        get 'tweets'
        get 'favorite_tweets'
      end
    end
    resources :follow_requests, only: [:create, :destroy] do
      delete 'reject', on: :member
    end
    resources :relationships, only: [:create, :destroy] do
      delete 'block', on: :member
    end
    resources :posts do
      resources :comments, only: [:create, :destroy]
      resource :bookmarks, only: [:create, :destroy]
      get 'bookmarking_users', on: :member
    end
    resources :tweets, only: [:index, :show, :create, :destroy] do
      resource :favorites, only: [:create, :destroy]
      get 'favoriting_users', on: :member
    end
  end

  namespace :admin do
    resources :users, only: [:index, :edit, :update]
  end

end
