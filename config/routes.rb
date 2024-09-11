Rails.application.routes.draw do
  get 'communities/index'
  # Deviseによるユーザー認証
  devise_for :users, controllers: {
    sessions: 'devise/sessions',
    passwords: 'devise/passwords',
    registrations: 'users/registrations'
  }

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
  resources :communities
  
  # 静的ページ
  get 'about', to: 'pages#about'
  get 'privacy_policy', to: 'pages#privacy_policy'
  get 'terms_of_service', to: 'pages#terms_of_service', as: 'terms_of_service'
  get 'contact', to: 'pages#contact', as: 'contact'

  # トップページ
  get 'top', to: 'users#top', as: 'top'
  
  # ログイン画面をrootに設定し、ログアウトルートも定義
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
end
