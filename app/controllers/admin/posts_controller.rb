# app/controllers/admin/posts_controller.rb
class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!  # 管理者認証
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)  # 全投稿を取得
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: '投稿が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: '投稿が削除されました。'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :image)  # 編集可能なパラメータ
  end
end
