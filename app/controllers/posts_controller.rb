class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :my_posts, :commented_posts]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

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
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to my_posts_posts_path }
      format.json { head :no_content }
    end
  end

  # 自分の投稿一覧
  def my_posts
    @posts = current_user.posts.where(community_id: nil) # コミュニティに属さない投稿のみ
                               .order(created_at: :desc)
                               .page(params[:page])
                               .per(20)
  end

  # コメントした投稿一覧を表示するアクション
  def commented_posts
    @posts = Post.joins(:comments)
                 .where(comments: { user_id: current_user.id }, community_id: nil) # コミュニティに属さない投稿のみ
                 .order('posts.created_at DESC')
                 .distinct.page(params[:page])
                 .per(20)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    redirect_to post_path unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :description, :image, :user_id)
  end
end
