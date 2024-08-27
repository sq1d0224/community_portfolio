class UsersController < ApplicationController
  before_action :authenticate_user!

  def top
    @user = current_user
    @posts = Post.order(created_at: :desc) # すべての投稿を取得
  end

  def index
    # 空のメソッド、今後の拡張用？
  end

  def show
    @user = current_user
    @post = Post.new
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(12)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_profile_path, notice: 'プロフィールを更新しました。'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :gender, :birthdate, :bio, :profile_image, :remove_profile_image)
  end
end
