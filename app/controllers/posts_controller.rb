class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :my_posts, :commented_posts]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :restrict_guest_user, only: [:new, :create, :edit, :update, :destroy, :my_posts, :commented_posts]

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
    @post = Post.find(params[:id])

    if @post.community_id.present?
      # コミュニティに関連する投稿の場合はコミュニティ詳細ページにリダイレクト
      community = @post.community
      @post.destroy
      redirect_to community_path(community)
    else
      # コミュニティに関連しない投稿の場合はマイ投稿一覧にリダイレクト
      @post.destroy
      redirect_to my_posts_posts_path
    end
  end

  # 自分の投稿一覧
  def my_posts
    if params[:search].present?
      @posts = current_user.posts.where(community_id: nil) # コミュニティに属さない投稿のみ
                                 .where("title LIKE ?", "%#{params[:search]}%")
                                 .or(current_user.posts.where("description LIKE ?", "%#{params[:search]}%"))
                                 .order(created_at: :desc)
                                 .page(params[:page])
                                 .per(20)
    else
      @posts = current_user.posts.where(community_id: nil) # コミュニティに属さない投稿のみ
                                 .order(created_at: :desc)
                                 .page(params[:page])
                                 .per(20)
    end
  end

  # コメントした投稿一覧を表示するアクション
  def commented_posts
    if params[:search].present?
      @posts = Post.joins(:comments)
                   .where(comments: { user_id: current_user.id }, community_id: nil)
                   .where("posts.title LIKE ?", "%#{params[:search]}%")
                   .or(Post.joins(:comments).where("posts.description LIKE ?", "%#{params[:search]}%").where(comments: { user_id: current_user.id }, community_id: nil))
                   .order('posts.created_at DESC')
                   .distinct
                   .page(params[:page])
                   .per(20)
    else
      @posts = Post.joins(:comments)
                   .where(comments: { user_id: current_user.id }, community_id: nil)
                   .order('posts.created_at DESC')
                   .distinct
                   .page(params[:page])
                   .per(20)
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    redirect_to post_path unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :description, :image, :user_id, :remove_image)
  end
  
  def restrict_guest_user
    if guest_user?
      redirect_to new_user_session_path, alert: '新規登録または、ログインしてください。'
    end
  end
  
end
