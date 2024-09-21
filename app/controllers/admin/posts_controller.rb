# app/controllers/admin/posts_controller.rb
class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!  # 管理者認証
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search].present?
      @posts = Post.where(community_id: nil) # コミュニティに属さない投稿のみ
                   .where("title LIKE ?", "%#{params[:search]}%")
                   .or(Post.where("description LIKE ?", "%#{params[:search]}%").where(community_id: nil))
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20)
    else
      @posts = Post.where(community_id: nil) # コミュニティに属さない投稿のみ
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :asc) # ここでコメントを取得
    @comments_count = @comments.size
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to admin_post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.community_id.present?
      # コミュニティに関連する投稿の場合はコミュニティ詳細ページにリダイレクト
      community = @post.community
      @post.destroy
      redirect_to admin_community_path(community)
    else
      # コミュニティに関連しない投稿の場合はマイ投稿一覧にリダイレクト
      @post.destroy
      redirect_to admin_posts_path
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :image, :user_id, :remove_image)
  end
end
