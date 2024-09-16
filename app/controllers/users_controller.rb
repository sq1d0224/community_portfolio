class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:edit, :update]

  def top
    @user = current_user
    @posts = Post.order(created_at: :desc) # すべての投稿を取得
  end

  def index
    # 検索がある場合とない場合の分岐
    if params[:search].present?
      # ユーザー名で検索
      @users = User.where("username LIKE ?", "%#{params[:search]}%")
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(15)
    else
      # 検索がない場合は全ユーザーを表示
      @users = User.order(created_at: :desc).page(params[:page]).per(15)
    end
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
