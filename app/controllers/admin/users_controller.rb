# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!  # 管理者認証

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
    @user = User.find(params[:id])  # ユーザー詳細を取得
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'ユーザーが削除されました。'
  end

  private

  def user_params
    params.require(:user).permit(:username, :gender, :birthdate, :bio, :profile_image, :remove_profile_image)  # 編集可能なパラメータ
  end
end
