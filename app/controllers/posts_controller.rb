class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :my_posts, :commented_posts]
  before_action :set_post, only: [:show, :edit, :update, :destroy] # 必要なアクションに限定
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :set_community, only: [:create_in_community]  # コミュニティをセットするアクション
  
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
    @post.destroy
    respond_to do |format|
      format.html { redirect_to my_posts_posts_path }
      format.json { head :no_content }
    end
  end
  
  # 自分の投稿一覧
  def my_posts
    @posts = current_user.posts.order(created_at: :desc).page(params[:page]).per(20)
  end
  
  # コメントした投稿一覧を表示するアクション
  def commented_posts
    # ログインしているユーザーがコメントした投稿を、投稿が新しい順で取得
    @posts = Post.joins(:comments)
                 .where(comments: { user_id: current_user.id })
                 .order('posts.created_at DESC') # 投稿が新しい順で並び替え
                 .distinct.page(params[:page]).per(20)
  end
  
  # コミュニティ内の投稿作成
  def create_in_community
    @post = @community.posts.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to community_path(@community), notice: 'コミュニティに投稿されました。'
    else
      render 'communities/show'  # エラーが出たらコミュニティの詳細ページにリダイレクト
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to post_path
    end
  end

  def post_params
    params.require(:post).permit(:title, :description, :image, :user_id)
  end
  
  def set_community
    @community = Community.find(params[:community_id])  # URLからコミュニティIDを取得
  end

  def post_params
    params.require(:post).permit(:title, :content, :image)  # タイトル、内容、画像を許可
  end
  
end
