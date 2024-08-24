Rails.application.routes.draw do
  get 'users/show'
  # Deviseによるユーザー認証
  devise_for :users, controllers: {
  sessions: 'devise/sessions',
  passwords: 'devise/passwords'
}

  # 投稿に関するルーティング
  resources :posts

  # プロフィールページに関連するルーティング
  get 'profile', to: 'users#show', as: 'user_profile'
  post 'profile', to: 'users#create_post'
  
   # プロフィール編集
  resources :users, only: [:edit, :update]

  # 静的ページやホームページに関連するルーティング
  # devise_scopeでログイン画面をrootに設定
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  
  get 'about', to: 'pages#about'
  
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'top', to: 'users#top', as: 'top'
  
  


end
