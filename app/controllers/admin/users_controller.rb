# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!  # 管理者認証

  def index
    @users = User.all.order(created_at: :desc)  # 全ユーザーを取得
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
      redirect_to admin_user_path(@user), notice: 'ユーザー情報が更新されました。'
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
