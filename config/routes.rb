Rails.application.routes.draw do
  # Deviseによるユーザー認証
  devise_for :users, controllers: {
    sessions: 'devise/sessions',
    passwords: 'devise/passwords',
    registrations: 'users/registrations'
  }

  resources :users, only: [:show] do
    member do
      get 'confirm_deactivation' # 退会確認ページ
      delete 'deactivate' # 退会処理
    end
  end

  # 投稿に関するルーティング
  resources :posts do
    collection do
      get 'my_posts'         # ログインユーザーの投稿一覧
      get 'commented_posts'  # ログインユーザーがコメントした投稿一覧
    end
    resources :comments, only: [:create, :destroy]  # コメントの作成・削除
  end

  # プロフィールページに関連するルーティング
  get 'profile', to: 'users#show', as: 'user_profile'
  post 'profile', to: 'users#create_post'

  # プロフィール編集
  resources :users, only: [:index, :show, :edit, :update]

  # コミュニティに関するルーティング
  resources :communities do
    resources :posts, controller: 'community_posts', only: [:new, :create]
    member do
      post 'join', to: 'communities#join'
      delete 'leave', to: 'communities#leave'
    end
    resources :posts, only: [:new, :create]
  end

  # 静的ページ
  get 'about', to: 'pages#about'
  get 'privacy_policy', to: 'pages#privacy_policy'
  get 'terms_of_service', to: 'pages#terms_of_service', as: 'terms_of_service'
  get 'contact', to: 'pages#contact', as: 'contact'
  
  # 作成したコミュニティ一覧
  get 'my_communities', to: 'users#my_communities', as: 'my_communities'

  # 参加中のコミュニティ一覧
  get 'joined_communities', to: 'users#joined_communities', as: 'joined_communities'

  # トップページ
  get 'top', to: 'users#top', as: 'top'

  # ログイン画面をrootに設定し、ログアウトルートも定義
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
end
