class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy, :join, :leave]
  
  def index
    @communities = Community.includes(:user, :users).page(params[:page]).per(10)
  
    if params[:search].present?
      @communities = @communities.where("title LIKE ?", "%#{params[:search]}%")
    end
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.communities.new(community_params) # current_userでコミュニティ作成
    if @community.save
      redirect_to communities_path
    else
      render :new
    end
  end
  
  def show
    # @communityはbefore_actionでセットされます
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

  private
  
  def set_community
    @community = Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:title, :description, :category, :image)
  end
end
