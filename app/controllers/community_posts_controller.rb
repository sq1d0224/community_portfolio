class CommunityPostsController < ApplicationController
  before_action :set_community
  before_action :authenticate_user!
  before_action :ensure_user_can_post, only: [:new, :create]
  before_action :restrict_guest_user, only: [:new, :create]

  # コミュニティ内での新規投稿画面を表示
  def new
    @post = @community.posts.new
  end

  # コミュニティ内での投稿作成
  def create
    @post = @community.posts.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to community_path(@community)
    else
      render :new
    end
  end

  private

  def post_params
    # コミュニティ投稿専用のバリデーションを適用
    params.require(:post).permit(:description, :image)
  end

  def set_community
    @community = Community.find(params[:community_id])
  end

  # コミュニティに参加しているか、または作成者かを確認する
  def ensure_user_can_post
    unless current_user == @community.user || current_user.joined_community?(@community)
      flash.now[:alert] = "コミュニティに参加してください。" # エラーメッセージをフラッシュに設定
      render 'communities/show' # コミュニティ詳細画面に戻る
    end
  end
  
  def restrict_guest_user
    if guest_user?
      redirect_to new_user_session_path, alert: '新規登録または、ログインしてください。'
    end
  end

end
