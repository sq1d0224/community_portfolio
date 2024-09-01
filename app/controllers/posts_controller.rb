class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  
  def index
    if params[:search].present?
      @posts = Post.where("title LIKE ?", "%#{params[:search]}%")
                   .or(Post.where("description LIKE ?", "%#{params[:search]}%"))
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20)
    else
      @posts = Post.order(created_at: :desc).page(params[:page]).per(20)
    end
  end
  
  def show
    # `set_post` により @post が設定されるので、ここでの処理は不要です。
    @post = Post.find(params[:id])
    @comments_count = @post.comments.count
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_path(@post), notice: '投稿が作成されました。'
    else
      render :new # ここで適切なビューを指定します。
    end
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to user_path(current_user), notice: '投稿が削除されました。'
    else
      redirect_to post_path(@post), alert: '投稿の削除に失敗しました。'
    end
  end


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to post_path, alert: '他のユーザーの投稿を編集することはできません。'
    end
  end

  def post_params
    params.require(:post).permit(:title, :description, :image, :user_id)
  end
end
