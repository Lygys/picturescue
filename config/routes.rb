Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }
  devise_for :users, skip: [:passwords, :registrations], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root to: 'homes#top'
  get 'search' => 'searchs#search'

  scope module: :public do
    resources :users, only: [:show, :edit, :update] do
      get :potential_followings, on: :member
      get :potential_followers, on: :member
      get :followings, on: :member
      get :followers, on: :member
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
