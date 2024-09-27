# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!  # 管理者認証
  before_action :set_user, only: [:show, :edit, :update, :confirm_deactivation, :destroy, :deactivate]

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
      # プロフィール画像が削除される場合、削除を遅延して処理
      if user_params[:remove_profile_image] == '1'
        @user.profile_image.purge_later # ActiveStorage の purge_later メソッドを使う
      end
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def confirm_deactivation
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])

    ActiveRecord::Base.transaction do
      # ユーザーが作成した投稿を削除
      @user.posts.destroy_all

      # ユーザーが作成したコメントを削除
      @user.comments.destroy_all

      # ユーザーが作成したコミュニティと、そのコミュニティに関連する投稿を削除
      @user.created_communities.each do |community|
        community.posts.destroy_all
        community.destroy
      end

      # ユーザーが他のコミュニティに投稿した投稿を削除
      Post.where(user_id: @user.id).destroy_all

      # ユーザーの物理削除
      @user.destroy
    end

    redirect_to admin_users_path
  rescue => e
    Rails.logger.error("退会処理中にエラーが発生しました: #{e.message}")
    flash[:error] = '退会処理中にエラーが発生しました。'
    redirect_to admin_user_path(@user)
  end

  def deactivate
    ActiveRecord::Base.transaction do
      # ユーザーを論理削除（退会扱いにする）
      @user.update!(is_deleted: true)

      # ユーザーが作成した投稿やコメントを削除
      @user.posts.destroy_all
      @user.comments.destroy_all

      # ユーザーが作成したコミュニティと投稿を削除
      @user.created_communities.each do |community|
        community.posts.destroy_all
        community.destroy
      end

      #  ユーザーがコミュニティに投稿した投稿を削除
      Post.where(user_id: @user.id).destroy_all
    end

    flash[:notice] = "ユーザーを退会させ、関連データを削除しました。"
    redirect_to admin_users_path
  rescue => e
    Rails.logger.error("退会処理中にエラーが発生しました: #{e.message}")
    flash[:error] = '退会処理中にエラーが発生しました。'
    redirect_to admin_user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:username, :gender, :birthdate, :bio, :profile_image, :remove_profile_image)  # 編集可能なパラメータ
  end

  def set_user
    @user = User.find(params[:id])
  end
end
