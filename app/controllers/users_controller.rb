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
  
  # 参加中のコミュニティを表示するアクション
  def my_communities
    @created_communities = current_user.communities
    @joined_communities = current_user.joined_communities
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
