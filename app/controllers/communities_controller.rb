class CommunitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :authorize_community_owner!, only: [:edit, :update, :destroy]
  before_action :restrict_guest_user, only: [:new, :create, :edit, :update, :destroy, :join, :leave]

  def index
    # コミュニティを新しく作成された順に取得
    if params[:search].present?
      @communities = Community.where("title LIKE ?", "%#{params[:search]}%")
                              .order(created_at: :desc)
                              .page(params[:page])
                              .per(10)
    else
      @communities = Community.order(created_at: :desc)
                              .page(params[:page])
                              .per(10)
    end
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.user = current_user # current_userを明示的に設定

    if @community.save
      redirect_to community_path(@community)
    else
      render :new
    end
  end

  def show
    # @communityはbefore_actionでセットされます
    # @community.posts にページネーションを適用
    # 検索機能
    if params[:search].present?
      @paginated_posts = @community.posts.where("description LIKE ?", "%#{params[:search]}%")
                                         .order(created_at: :desc)
                                         .page(params[:page])
                                         .per(10)
    else
      @paginated_posts = @community.posts.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def edit
    # 編集フォームを表示
  end

  def update
    if @community.update(community_params)
      redirect_to @community, notice: 'コミュニティが正常に更新されました。'
    else
      render :edit
    end
  end

  # コミュニティに参加するアクション
  def join
    unless current_user.communities.include?(@community)
      current_user.communities << @community
      flash[:notice] = "コミュニティに参加しました。"
    else
      flash[:alert] = "すでにこのコミュニティに参加しています。"
    end
    redirect_to @community
  end

  # コミュニティを退会するアクション
  def leave
    if current_user.communities.include?(@community)
      current_user.communities.delete(@community)
      flash[:notice] = "コミュニティを退会しました。"
    else
      flash[:alert] = "このコミュニティに参加していません。"
    end
    redirect_to @community
  end

  def destroy
    if @community.destroy
      redirect_to communities_path
    else
      redirect_to community_path(@community)
    end
  end

  private

  def set_community
    @community = Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:title, :description, :category, :image)
  end

  # 管理者かどうかを確認するメソッド
  def authorize_community_owner!
    unless current_user == @community.user
      redirect_to community_path
    end
  end

end
