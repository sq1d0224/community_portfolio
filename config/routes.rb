Rails.application.routes.draw do
  # Deviseによるユーザー認証
  devise_for :users, controllers: {
    sessions: 'devise/sessions',
    passwords: 'devise/passwords',
    registrations: 'users/registrations'
  }

  # 投稿に関するルーティング
  resources :posts
  
  # コメントに関するルーティング
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  # プロフィールページに関連するルーティング
  get 'profile', to: 'users#show', as: 'user_profile'
  post 'profile', to: 'users#create_post'

  # プロフィール編集
  resources :users, only: [:index, :show, :edit, :update]
  
  # トップページにリダイレクト
  # get '/users', to: redirect('/')

  # 静的ページ
  get 'about', to: 'pages#about'

  # トップページ
  get 'top', to: 'users#top', as: 'top'
  
  # プライバシーポリシーページ
  get 'privacy_policy', to: 'pages#privacy_policy'
  
  # 利用規約ページ
  get 'terms_of_service', to: 'pages#terms_of_service', as: 'terms_of_service'
  
  # お問い合わせページ
  get 'contact', to: 'pages#contact', as: 'contact'
  
  # 現在ログインしているユーザーがコメントした投稿を表示するルートを追加
  get 'commented_posts', to: 'posts#commented_posts'

  # ログイン画面をrootに設定し、ログアウトルートも定義
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
end
