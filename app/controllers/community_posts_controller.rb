class CommunityPostsController < ApplicationController
  before_action :set_community
  before_action :authenticate_user!

  # コミュニティ内での新規投稿画面を表示
  def new
    @post = @community.posts.new
  end

  # コミュニティ内での投稿作成
  def create
    @post = @community.posts.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to community_path(@community), notice: '投稿が作成されました。'
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
end
