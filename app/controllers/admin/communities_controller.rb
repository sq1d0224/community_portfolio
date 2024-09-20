# app/controllers/admin/communities_controller.rb
class Admin::CommunitiesController < ApplicationController
  before_action :authenticate_admin!  # 管理者認証

  def index
    @communities = Community.all.order(created_at: :desc)  # 全コミュニティを取得
  end

  def show
    @community = Community.find(params[:id])  # コミュニティ詳細を取得
    @posts = @community.posts  # コミュニティに関連する投稿
  end

  def destroy
    @community = Community.find(params[:id])
    @community.destroy
    redirect_to admin_communities_path, notice: 'コミュニティが削除されました。'
  end
end
