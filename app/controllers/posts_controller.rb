class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :my_posts, :commented_posts]
  before_action :set_post, only: [:show, :edit, :update, :destroy] # 必要なアクションに限定
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
    # `set_post` により @post が設定される
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
      render :new
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
    user = @post.user # 削除前にユーザーをキャッシュ
    @post.destroy
    respond_to do |format|
      format.html { redirect_to user_path(user), notice: '投稿が正常に削除されました。' }
      format.json { head :no_content }
    end
  end
  
  # 自分の投稿一覧
  def my_posts
    @posts = current_user.posts.order(created_at: :desc).page(params[:page]).per(20)
  end
  
  # コメントした投稿一覧を表示するアクション
  def commented_posts
    @posts = Post.joins(:comments).where(comments: { user_id: current_user.id }).distinct.page(params[:page]).per(20)
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
