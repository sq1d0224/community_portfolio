class CommunityPostsController < ApplicationController
  before_action :set_community
  before_action :authenticate_user!
  before_action :ensure_user_can_post, only: [:new, :create]

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
      render 'communities/show' # コミュニティ詳細画面にエラーを持ってリダイレクト
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

  # コミュニティに参加しているか、作成者かを確認する
  def ensure_user_can_post
    unless current_user == @community.user || current_user.joined_community?(@community)
      flash[:alert] = I18n.t('community.join.failure')
      redirect_to community_path(@community)
    end
  end

end
