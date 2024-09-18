class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :restrict_guest_user, only: [:edit, :update, :deactivate, :my_communities, :joined_communities]

  def top

  end

  def index
    # 退会済みユーザー（is_deleted が true のユーザー）とゲストユーザーを除外
    base_users = User.where("is_deleted = ? OR is_deleted IS NULL", false)
                     .where.not(email: 'guest@example.com')
    # ログで確認
    Rails.logger.debug "Filtered Users: #{base_users.map(&:username)}"
    # 検索条件がある場合
    if params[:search].present?
      @users = base_users.where("username LIKE ?", "%#{params[:search]}%")
    else
      # 検索条件がない場合
      @users = base_users
    end
    # ページネーション
    @users = @users.order(created_at: :desc).page(params[:page]).per(15)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    is_matching_login_user
    @user = User.find(params[:id])
  end

  def update
    is_matching_login_user
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  # 作成したコミュニティの一覧
  def my_communities
    # ユーザーが作成したコミュニティをページネーション付きで取得
    @created_communities = current_user.created_communities
                                      .order(created_at: :desc)  # 新しい順に並び替え
                                      .page(params[:page])       # Kaminariによるページネーション
                                      .per(10)                  # 1ページあたり10件表示
    if params[:search].present?
      @created_communities = @created_communities.where("title LIKE ?", "%#{params[:search]}%")
    end
  end

  # 参加中のコミュニティの一覧
  def joined_communities
    @joined_communities = current_user.joined_communities
                                      .order(created_at: :desc)  # 新しい順に並び替え
                                      .page(params[:page])       # Kaminariによるページネーション
                                      .per(10)                  # 1ページあたり10件表示
    if params[:search].present?
      @joined_communities = @joined_communities.where("title LIKE ?", "%#{params[:search]}%")
    end
  end
  
  
  def guest_dashboard
    # ゲストユーザー専用のダッシュボードアクション
  end


   # 退会処理アクション
  def deactivate
    current_user.update(
      name: '退会ユーザー', # ユーザー名を「退会ユーザー」に変更
      email: "deleted_#{current_user.id}@example.com", # メールアドレスを無効なものに変更
      profile_image: nil, # プロフィール画像を削除
      is_deleted: true # 退会フラグを立てる
    )
    sign_out current_user # ログアウト処理
    redirect_to root_path, notice: 'アカウントを退会しました。'
  end


  private

  def user_params
    params.require(:user).permit(:username, :gender, :birthdate, :bio, :profile_image, :remove_profile_image)
  end

  def is_matching_login_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path
    end
  end

end
